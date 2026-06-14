import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../domain/entities/dashboard_stats.dart';
import 'dashboard_datasource.dart';

class DashboardDatasourceImpl implements DashboardDatasource {
  final SupabaseClient supabase;
  DashboardDatasourceImpl(this.supabase);

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  @override
  Future<DashboardStats> getDashboardStats({
    required String role,
    String? uniteId,
  }) async {
    try {
      final filtrer = !_estAccesGlobal(role) && uniteId != null;

      final results = await Future.wait([
        _getMilitantsStats(filtrer, uniteId),
        _getFinancesStats(filtrer, uniteId),
        _getEvolutionMilitants(filtrer, uniteId),
        _getEvolutionFinances(filtrer, uniteId),
        _getCellulesCount(filtrer, uniteId),
      ]);

      final activite = _activiteVide()
        ..['nombre_cellules'] = results[4] as int;

      return DashboardStatsModel.fromSupabase(
        militants:             results[0] as Map<String, dynamic>,
        finances:              results[1] as Map<String, dynamic>,
        activite:              activite,
        evolutionMilitantsRaw: results[2] as List<Map<String, dynamic>>,
        evolutionFinancesRaw:  results[3] as List<Map<String, dynamic>>,
      );
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Dashboard] Erreur inattendue: $e\n$stack');
      throw const NetworkException();
    }
  }

  Future<Map<String, dynamic>> _getMilitantsStats(bool filtrer, String? uniteId) async {
    final now      = DateTime.now();
    final debutMois = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';

    var query = supabase
        .from(AppTables.militants)
        .select('${AppTables.colSexe}, ${AppTables.colDateAdhesion}')
        .eq(AppTables.colStatut, AppEnums.militantActif);
    if (filtrer) query = query.eq(AppTables.colUniteId, uniteId!);

    final data        = await query;
    final total       = data.length;
    final debutMoisDt = DateTime.parse(debutMois);
    final debutAnnee  = DateTime(now.year, 1, 1);
    final nouveaux    = data.where((m) {
      final d = m[AppTables.colDateAdhesion] as String?;
      return d != null && !DateTime.parse(d).isBefore(debutMoisDt);
    }).length;
    final nouveauxAnnee = data.where((m) {
      final d = m[AppTables.colDateAdhesion] as String?;
      return d != null && !DateTime.parse(d).isBefore(debutAnnee);
    }).length;
    final hommes  = data.where((m) => m[AppTables.colSexe] == AppEnums.sexeHomme).length;
    final femmes  = data.where((m) => m[AppTables.colSexe] == AppEnums.sexeFemme).length;

    return {
      'total':                total,
      'nouveaux_ce_mois':     nouveaux,
      'nouveaux_cette_annee': nouveauxAnnee,
      'pct_hommes':           total > 0 ? hommes / total * 100 : 0.0,
      'pct_femmes':           total > 0 ? femmes / total * 100 : 0.0,
    };
  }

  Future<Map<String, dynamic>> _getFinancesStats(bool filtrer, String? uniteId) async {
    var txQuery = supabase
        .from(AppTables.transactions)
        .select('${AppTables.colType}, ${AppTables.colMontant}');
    if (filtrer) txQuery = txQuery.eq(AppTables.colUniteId, uniteId!);

    final transactions = await txQuery;
    double entrees = 0;
    double depenses = 0;
    for (final t in transactions) {
      final montant = (t[AppTables.colMontant] as num).toDouble();
      if (t[AppTables.colType] == AppEnums.transactionEntree) entrees += montant;
      else depenses += montant;
    }

    final annee = DateTime.now().year;
    final cotisations = await supabase
        .from(AppTables.cotisations)
        .select(AppTables.colStatutCotis)
        .eq(AppTables.colAnnee, annee);

    final totalCotis       = cotisations.length;
    final payees           = cotisations.where((c) => c[AppTables.colStatutCotis] == AppEnums.cotisationPayee).length;
    final tauxRecouvrement = totalCotis > 0 ? payees / totalCotis * 100 : 0.0;

    return {
      'solde':             entrees - depenses,
      'taux_recouvrement': tauxRecouvrement,
      'total_entrees':     entrees,
    };
  }

  Future<List<Map<String, dynamic>>> _getEvolutionMilitants(bool filtrer, String? uniteId) async {
    final debutStr = _debut6Mois();
    var query = supabase
        .from(AppTables.militants)
        .select(AppTables.colDateAdhesion)
        .eq(AppTables.colStatut, AppEnums.militantActif)
        .gte(AppTables.colDateAdhesion, debutStr);
    if (filtrer) query = query.eq(AppTables.colUniteId, uniteId!);

    final data = await query;
    return _grouperParMois(data, AppTables.colDateAdhesion);
  }

  Future<List<Map<String, dynamic>>> _getEvolutionFinances(bool filtrer, String? uniteId) async {
    final debutStr = _debut6Mois();
    var query = supabase
        .from(AppTables.transactions)
        .select('${AppTables.colType}, ${AppTables.colMontant}, ${AppTables.colDateTransaction}')
        .gte(AppTables.colDateTransaction, debutStr);
    if (filtrer) query = query.eq(AppTables.colUniteId, uniteId!);

    final transactions = await query;
    final Map<String, double> parMois = _initialiseMois();

    for (final t in transactions) {
      final cle    = '${(t[AppTables.colDateTransaction] as String).substring(0, 7)}-01';
      final montant = (t[AppTables.colMontant] as num).toDouble();
      if (parMois.containsKey(cle)) {
        parMois[cle] = parMois[cle]! +
            (t[AppTables.colType] == AppEnums.transactionEntree ? montant : -montant);
      }
    }

    return parMois.entries.map((e) => {'mois': e.key, 'solde': e.value}).toList();
  }

  // Regroupe les rows par mois (compte le nombre d'occurrences)
  List<Map<String, dynamic>> _grouperParMois(List<dynamic> rows, String champDate) {
    final Map<String, int> parMois = _initialiseMois().map((k, _) => MapEntry(k, 0));
    for (final row in rows) {
      final cle = '${(row[champDate] as String).substring(0, 7)}-01';
      if (parMois.containsKey(cle)) parMois[cle] = parMois[cle]! + 1;
    }
    return parMois.entries.map((e) => {'mois': e.key, 'total': e.value}).toList();
  }

  // Date de début de la fenêtre des 6 mois glissants
  String _debut6Mois() {
    final now = DateTime.now();
    final m   = DateTime(now.year, now.month - (AppConstants.nombreMoisGraphique - 1), 1);
    return '${m.year}-${m.month.toString().padLeft(2, '0')}-01';
  }

  // Initialise les 6 derniers mois à zéro (du plus ancien au plus récent)
  Map<String, double> _initialiseMois() {
    final now = DateTime.now();
    final Map<String, double> mois = {};
    for (int i = AppConstants.nombreMoisGraphique - 1; i >= 0; i--) {
      final m   = DateTime(now.year, now.month - i, 1);
      mois['${m.year}-${m.month.toString().padLeft(2, '0')}-01'] = 0;
    }
    return mois;
  }

  Future<int> _getCellulesCount(bool filtrer, String? uniteId) async {
    var query = supabase
        .from(AppTables.unitesOrganisationnelles)
        .select('id')
        .eq(AppTables.colType, AppUniteTypes.cellule);
    if (filtrer && uniteId != null) {
      query = query.eq(AppTables.colParentId, uniteId);
    }
    final data = await query;
    return data.length;
  }

  Map<String, dynamic> _activiteVide() => {
    'prospects_actifs':     0,
    'taux_conversion':      0.0,
    'evenements_ce_mois':   0,
    'evenements_a_venir':   0,
    'decisions_en_attente': 0,
    'actions_en_retard':    0,
    'nombre_cellules':      0,
  };
}