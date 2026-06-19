import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart'; // AppUniteTypes, AppEnums, AppRoles
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/militants_datasource_impl.dart';
import '../../data/repositories/militants_repository_impl.dart';
import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/militants_repository.dart';
import '../../domain/usecases/ajouter_militant.dart';
import '../../domain/usecases/creer_cellule.dart';
import '../../domain/usecases/get_militants.dart';
import '../../domain/usecases/get_unites.dart';
import '../../domain/usecases/modifier_militant.dart';
import '../../domain/usecases/toggle_statut_militant.dart';

part 'militants_provider.freezed.dart';

// --- État ---

@freezed
class MilitantsState with _$MilitantsState {
  const MilitantsState._();

  const factory MilitantsState.initial()                          = _Initial;
  const factory MilitantsState.chargement()                      = _Chargement;
  const factory MilitantsState.charge({
    required List<Militant> militants,
    required List<UniteOrganisationnelle> unites,
    @Default('') String recherche,
    String? filtreStatut,
  }) = _Charge;
  const factory MilitantsState.erreur({required Failure failure}) = _Erreur;

  List<Militant> get militantsFiltres => maybeWhen(
        charge: (militants, _, recherche, filtreStatut) {
          var liste = militants;
          if (filtreStatut != null) {
            liste = liste.where((m) => m.statut == filtreStatut).toList();
          }
          if (recherche.isNotEmpty) {
            final q = recherche.toLowerCase();
            liste = liste
                .where((m) =>
                    m.nom.toLowerCase().contains(q) ||
                    m.prenom.toLowerCase().contains(q) ||
                    (m.email?.toLowerCase().contains(q) ?? false) ||
                    (m.telephone?.contains(q) ?? false) ||
                    (m.ville?.toLowerCase().contains(q) ?? false))
                .toList();
          }
          return liste;
        },
        orElse: () => [],
      );

  int get totalActifs => maybeWhen(
        charge: (militants, _, __, ___) =>
            militants.where((m) => m.statut == AppEnums.militantActif).length,
        orElse: () => 0,
      );

  int get nouveauxCeMois => maybeWhen(
        charge: (militants, _, __, ___) {
          final debut =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          return militants
              .where((m) =>
                  m.statut == AppEnums.militantActif &&
                  !m.dateAdhesion.isBefore(debut))
              .length;
        },
        orElse: () => 0,
      );

  int get variationVsMoisDernier => maybeWhen(
        charge: (militants, _, __, ___) {
          final now       = DateTime.now();
          final debutCe   = DateTime(now.year, now.month, 1);
          final debutPrec = DateTime(now.year, now.month - 1, 1);
          final ce   = militants
              .where((m) => !m.dateAdhesion.isBefore(debutCe))
              .length;
          final prec = militants
              .where((m) =>
                  !m.dateAdhesion.isBefore(debutPrec) &&
                  m.dateAdhesion.isBefore(debutCe))
              .length;
          return ce - prec;
        },
        orElse: () => 0,
      );

  double get pourcentageHommes => maybeWhen(
        charge: (militants, _, __, ___) {
          final actifs =
              militants.where((m) => m.statut == AppEnums.militantActif).toList();
          if (actifs.isEmpty) return 0;
          return actifs.where((m) => m.sexe == AppEnums.sexeHomme).length /
              actifs.length *
              100;
        },
        orElse: () => 0.0,
      );

  double get pourcentageFemmes => maybeWhen(
        charge: (militants, _, __, ___) {
          final actifs =
              militants.where((m) => m.statut == AppEnums.militantActif).toList();
          if (actifs.isEmpty) return 0;
          return actifs.where((m) => m.sexe == AppEnums.sexeFemme).length /
              actifs.length *
              100;
        },
        orElse: () => 0.0,
      );

  List<(DateTime, int)> get evolutionNouveaux => maybeWhen(
        charge: (militants, _, __, ___) => List.generate(
          AppConstants.nombreMoisGraphique,
          (i) {
            final now  = DateTime.now();
            final mois = DateTime(
                now.year, now.month - (AppConstants.nombreMoisGraphique - 1 - i), 1);
            final finMois = DateTime(mois.year, mois.month + 1, 0);
            final count = militants
                .where((m) =>
                    !m.dateAdhesion.isBefore(mois) &&
                    !m.dateAdhesion.isAfter(finMois))
                .length;
            return (mois, count);
          },
        ),
        orElse: () => [],
      );

  // Tuple: (nom, count, objectif, nouveauxCeMois, code, sousTitre?)
  List<(String, int, int, int, String?, String?)> get statsParSousSection => maybeWhen(
        charge: (militants, unites, _, __) {
          final unitesMap   = {for (final u in unites) u.id: u};
          final sousSections = unites.where((u) => u.type == AppUniteTypes.sousSection).toList();
          final celSS = <String, String>{};
          for (final u in unites.where((u) => u.type == AppUniteTypes.cellule)) {
            if (u.parentId != null) celSS[u.id] = u.parentId!;
          }
          final counts   = <String, int>{for (final ss in sousSections) ss.id: 0};
          final nouveaux = <String, int>{for (final ss in sousSections) ss.id: 0};
          final now       = DateTime.now();
          final debutMois = DateTime(now.year, now.month, 1);
          final total =
              militants.where((m) => m.statut == AppEnums.militantActif).length;
          for (final m
              in militants.where((m) => m.statut == AppEnums.militantActif)) {
            final unite = unitesMap[m.uniteId];
            if (unite == null) continue;
            String? ssId;
            if (unite.type == AppUniteTypes.sousSection) ssId = unite.id;
            else if (unite.type == AppUniteTypes.cellule) ssId = celSS[unite.id];
            if (ssId == null || !counts.containsKey(ssId)) continue;
            counts[ssId] = counts[ssId]! + 1;
            if (!m.dateAdhesion.isBefore(debutMois)) {
              nouveaux[ssId] = nouveaux[ssId]! + 1;
            }
          }
          return sousSections
              .map((ss) {
                final count = counts[ss.id] ?? 0;
                final ratio = total > 0 && count > 0 ? count / total : 0.0;
                final obj = count > 0
                    ? (AppConstants.objectifMilitants * ratio)
                        .round()
                        .clamp(AppConstants.objectifMinSousSection, AppConstants.objectifMilitants)
                    : AppConstants.objectifMinSousSection;
                return (ss.nom, count, obj, nouveaux[ss.id] ?? 0, ss.code, null);
              })
              .toList()
            ..sort((a, b) => b.$2.compareTo(a.$2));
        },
        orElse: () => [],
      );

  List<(String, int, int, int, String?, String?)> get statsParMouvement => maybeWhen(
        charge: (militants, unites, _, __) {
          final mouvements = unites.where((u) => u.type == AppUniteTypes.mouvement).toList();
          if (mouvements.isEmpty) return [];
          final now       = DateTime.now();
          final debutMois = DateTime(now.year, now.month, 1);
          final total =
              militants.where((m) => m.statut == AppEnums.militantActif).length;
          final counts   = <String, int>{for (final mv in mouvements) mv.id: 0};
          final nouveaux = <String, int>{for (final mv in mouvements) mv.id: 0};
          for (final m
              in militants.where((m) => m.statut == AppEnums.militantActif)) {
            if (!counts.containsKey(m.uniteId)) continue;
            counts[m.uniteId] = counts[m.uniteId]! + 1;
            if (!m.dateAdhesion.isBefore(debutMois)) {
              nouveaux[m.uniteId] = nouveaux[m.uniteId]! + 1;
            }
          }
          final result = mouvements
              .map((mv) {
                final count = counts[mv.id] ?? 0;
                final ratio = total > 0 && count > 0 ? count / total : 0.0;
                final obj = count > 0
                    ? (AppConstants.objectifMilitants * ratio)
                        .round()
                        .clamp(AppConstants.objectifMinSousSection, AppConstants.objectifMilitants)
                    : AppConstants.objectifMinSousSection;
                return (mv.nom, count, obj, nouveaux[mv.id] ?? 0, mv.code, null);
              })
              .toList();
          result.sort((a, b) => b.$2.compareTo(a.$2));
          return result;
        },
        orElse: () => [],
      );

  List<(String, int, int, int, String?, String?)> get statsParCellule => maybeWhen(
        charge: (militants, unites, _, __) {
          final cellules = unites.where((u) => u.type == AppUniteTypes.cellule).toList();
          if (cellules.isEmpty) return [];
          final unitesMap = {for (final u in unites) u.id: u};
          final now       = DateTime.now();
          final debutMois = DateTime(now.year, now.month, 1);
          final total =
              militants.where((m) => m.statut == AppEnums.militantActif).length;
          final counts   = <String, int>{for (final c in cellules) c.id: 0};
          final nouveaux = <String, int>{for (final c in cellules) c.id: 0};
          for (final m
              in militants.where((m) => m.statut == AppEnums.militantActif)) {
            if (!counts.containsKey(m.uniteId)) continue;
            counts[m.uniteId] = counts[m.uniteId]! + 1;
            if (!m.dateAdhesion.isBefore(debutMois)) {
              nouveaux[m.uniteId] = nouveaux[m.uniteId]! + 1;
            }
          }
          final result = cellules
              .map((c) {
                final count = counts[c.id] ?? 0;
                final ratio = total > 0 && count > 0 ? count / total : 0.0;
                final obj = count > 0
                    ? (AppConstants.objectifMilitants * ratio)
                        .round()
                        .clamp(AppConstants.objectifMinCellule, AppConstants.objectifMilitants)
                    : AppConstants.objectifMinCellule;
                final parentSS = c.parentId != null ? unitesMap[c.parentId] : null;
                final ssLabel = parentSS?.nom;
                return (c.nom, count, obj, nouveaux[c.id] ?? 0, c.code, ssLabel);
              })
              .toList();
          result.sort((a, b) => b.$2.compareTo(a.$2));
          return result;
        },
        orElse: () => [],
      );

  List<(String, int, int, int, String?, String?)> get statsParSecretariat => maybeWhen(
        charge: (militants, unites, _, __) {
          final secretariats = unites.where((u) => u.type == AppUniteTypes.secretariat).toList();
          if (secretariats.isEmpty) return [];
          final now       = DateTime.now();
          final debutMois = DateTime(now.year, now.month, 1);
          final total =
              militants.where((m) => m.statut == AppEnums.militantActif).length;
          final counts   = <String, int>{for (final s in secretariats) s.id: 0};
          final nouveaux = <String, int>{for (final s in secretariats) s.id: 0};
          for (final m
              in militants.where((m) => m.statut == AppEnums.militantActif)) {
            if (!counts.containsKey(m.uniteId)) continue;
            counts[m.uniteId] = counts[m.uniteId]! + 1;
            if (!m.dateAdhesion.isBefore(debutMois)) {
              nouveaux[m.uniteId] = nouveaux[m.uniteId]! + 1;
            }
          }
          final result = secretariats
              .map((s) {
                final count = counts[s.id] ?? 0;
                final ratio = total > 0 && count > 0 ? count / total : 0.0;
                final obj = count > 0
                    ? (AppConstants.objectifMilitants * ratio)
                        .round()
                        .clamp(AppConstants.objectifMinCellule, AppConstants.objectifMilitants)
                    : AppConstants.objectifMinCellule;
                return (s.nom, count, obj, nouveaux[s.id] ?? 0, s.code, null);
              })
              .toList();
          result.sort((a, b) => b.$2.compareTo(a.$2));
          return result;
        },
        orElse: () => [],
      );

  int countActifsForFilter(String? filtreType) => maybeWhen(
        charge: (militants, unites, _, __) {
          if (filtreType == null) {
            return militants
                .where((m) => m.statut == AppEnums.militantActif)
                .length;
          }
          if (filtreType == AppUniteTypes.sousSection) {
            final ssIds = unites
                .where((u) => u.type == AppUniteTypes.sousSection)
                .map((u) => u.id)
                .toSet();
            final validIds = unites.where((u) {
              if (u.type == AppUniteTypes.sousSection) return true;
              if (u.type == AppUniteTypes.cellule &&
                  u.parentId != null &&
                  ssIds.contains(u.parentId)) return true;
              return false;
            }).map((u) => u.id).toSet();
            return militants
                .where((m) =>
                    m.statut == AppEnums.militantActif &&
                    validIds.contains(m.uniteId))
                .length;
          }
          final ids = unites
              .where((u) => u.type == filtreType)
              .map((u) => u.id)
              .toSet();
          return militants
              .where((m) =>
                  m.statut == AppEnums.militantActif && ids.contains(m.uniteId))
              .length;
        },
        orElse: () => 0,
      );

  int get nbCellulesActives => maybeWhen(
        charge: (militants, unites, _, __) {
          final celIds = unites
              .where((u) => u.type == AppUniteTypes.cellule)
              .map((u) => u.id)
              .toSet();
          return militants
              .where((m) =>
                  m.statut == AppEnums.militantActif && celIds.contains(m.uniteId))
              .map((m) => m.uniteId)
              .toSet()
              .length;
        },
        orElse: () => 0,
      );

  String get variationCeTrimestre => maybeWhen(
        charge: (militants, _, __, ___) {
          final now          = DateTime.now();
          final moisDebut    = ((now.month - 1) ~/ 3) * 3 + 1;
          final debutCe      = DateTime(now.year, moisDebut, 1);
          final debutPrec    = DateTime(debutCe.year, debutCe.month - 3, 1);
          final ceTrim  = militants.where((m) => !m.dateAdhesion.isBefore(debutCe)).length;
          final precTrim = militants.where((m) =>
              !m.dateAdhesion.isBefore(debutPrec) &&
              m.dateAdhesion.isBefore(debutCe)).length;
          if (precTrim == 0) return ceTrim > 0 ? '+$ceTrim ce trim.' : '—';
          final v = (ceTrim - precTrim) / precTrim * 100;
          return '${v >= 0 ? '+' : ''}${v.toStringAsFixed(1)}% ce trim.';
        },
        orElse: () => '—',
      );
}

// --- Providers d'infrastructure ---

final militantsDatasourceProvider = Provider(
  (ref) => MilitantsDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final militantsRepositoryProvider = Provider(
  (ref) => MilitantsRepositoryImpl(ref.watch(militantsDatasourceProvider)),
);

// --- Notifier ---

final militantsProvider =
    StateNotifierProvider<MilitantsNotifier, MilitantsState>(
  (ref) => MilitantsNotifier(
    getMilitants:        GetMilitants(ref.watch(militantsRepositoryProvider)),
    getUnites:           GetUnites(ref.watch(militantsRepositoryProvider)),
    ajouterMilitant:     AjouterMilitant(ref.watch(militantsRepositoryProvider)),
    modifierMilitant:    ModifierMilitant(ref.watch(militantsRepositoryProvider)),
    toggleStatutMilitant: ToggleStatutMilitant(ref.watch(militantsRepositoryProvider)),
    creerCellule:        CreerCellule(ref.watch(militantsRepositoryProvider)),
    ref: ref,
  ),
);

class MilitantsNotifier extends StateNotifier<MilitantsState> {
  final GetMilitants         _getMilitants;
  final GetUnites            _getUnites;
  final AjouterMilitant      _ajouterMilitant;
  final ModifierMilitant     _modifierMilitant;
  final ToggleStatutMilitant _toggleStatut;
  final CreerCellule         _creerCellule;
  final Ref                  _ref;

  MilitantsNotifier({
    required GetMilitants getMilitants,
    required GetUnites getUnites,
    required AjouterMilitant ajouterMilitant,
    required ModifierMilitant modifierMilitant,
    required ToggleStatutMilitant toggleStatutMilitant,
    required CreerCellule creerCellule,
    required Ref ref,
  })  : _getMilitants = getMilitants,
        _getUnites = getUnites,
        _ajouterMilitant = ajouterMilitant,
        _modifierMilitant = modifierMilitant,
        _toggleStatut = toggleStatutMilitant,
        _creerCellule = creerCellule,
        _ref = ref,
        super(const MilitantsState.initial()) {
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => charger());
    });
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const MilitantsState.chargement();

    final authState   = _ref.read(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      final enAttente = authState.whenOrNull(initial: () => true, chargement: () => true) ?? false;
      if (!enAttente) { state = const MilitantsState.erreur(failure: Failure.nonAutorise()); }
      return;
    }

    final filtrer = !_estAccesGlobal(utilisateur.role);
    final uniteId = filtrer ? utilisateur.uniteOrganisationnelleId : null;

    final results = await Future.wait([
      _getMilitants(ParamsGetMilitants(uniteId: uniteId)),
      _getUnites(const NoParams()),
    ]);

    final militants = results[0] as Either<Failure, List<Militant>>;
    final unites    = results[1] as Either<Failure, List<UniteOrganisationnelle>>;

    if (militants.isLeft()) {
      state = MilitantsState.erreur(
          failure: militants.fold((f) => f, (_) => const Failure.reseau()));
      return;
    }

    state = MilitantsState.charge(
      militants: militants.getOrElse(() => []),
      unites:    unites.getOrElse(() => []),
    );
  }

  void modifierRecherche(String q) {
    state.maybeWhen(
      charge: (m, u, _, filtreStatut) => state = MilitantsState.charge(
        militants:    m,
        unites:       u,
        recherche:    q,
        filtreStatut: filtreStatut,
      ),
      orElse: () {},
    );
  }

  void modifierFiltreStatut(String? statut) {
    state.maybeWhen(
      charge: (m, u, recherche, _) => state = MilitantsState.charge(
        militants:    m,
        unites:       u,
        recherche:    recherche,
        filtreStatut: statut,
      ),
      orElse: () {},
    );
  }

  Future<Either<Failure, void>> ajouterMilitant(
      ParamsAjouterMilitant params) async {
    final result = await _ajouterMilitant(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }

  Future<Either<Failure, void>> modifierMilitant(
      ParamsModifierMilitant params) async {
    final result = await _modifierMilitant(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }

  Future<Either<Failure, void>> toggleStatut(
      String id, String nouveauStatut) async {
    final result = await _toggleStatut(
        ParamsToggleStatut(id: id, nouveauStatut: nouveauStatut));
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, int>> importerMilitants(
      List<Map<String, dynamic>> rows) async {
    final result = await _ref
        .read(militantsRepositoryProvider)
        .importerMilitants(rows);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, UniteOrganisationnelle>> creerCellule(
      ParamsCreerCellule params) async {
    final result = await _creerCellule(params);
    if (result.isRight()) await charger();
    return result;
  }
}