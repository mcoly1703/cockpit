import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/resultat_scan.dart';

class ScanDatasource {
  final SupabaseClient supabase;
  ScanDatasource(this.supabase);

  Future<ResultatScan> scannerCarte(String militantId) async {
    try {
      // Recherche le militant
      final militants = await supabase
          .from(AppTables.militants)
          .select('${AppTables.colNom}, ${AppTables.colPrenom}, '
              '${AppTables.colStatut}, ${AppTables.colNumeroCarte}')
          .eq(AppTables.colId, militantId)
          .limit(1);

      if (militants.isEmpty) return const ResultatScan.inconnu();

      final m = militants.first;
      final nom     = m[AppTables.colNom]    as String;
      final prenom  = m[AppTables.colPrenom] as String;
      final statut  = m[AppTables.colStatut] as String;
      final carte   = m[AppTables.colNumeroCarte] as String?;

      if (statut == AppEnums.militantSuspendu || statut == AppEnums.militantInactif) {
        return ResultatScan.suspendu(nom: nom, prenom: prenom);
      }

      // Vérifie la cotisation du mois courant
      final now      = DateTime.now();
      final cotisations = await supabase
          .from(AppTables.cotisations)
          .select('${AppTables.colStatutCotis}, ${AppTables.colAnnee}, ${AppTables.colMois}')
          .eq(AppTables.colMilitantId, militantId)
          .eq(AppTables.colAnnee, now.year)
          .eq(AppTables.colMois, now.month)
          .limit(1);

      if (cotisations.isNotEmpty) {
        final statutCotis = cotisations.first[AppTables.colStatutCotis] as String;
        if (statutCotis == AppEnums.cotisationEnRetard) {
          return ResultatScan.retard(
            nom: nom, prenom: prenom, numeroCarte: carte,
            periodeRetard: '${_nomMois(now.month)} ${now.year}',
          );
        }
        return ResultatScan.valide(
          nom: nom, prenom: prenom, numeroCarte: carte,
          statutCotis: statutCotis,
        );
      }

      // Pas de cotisation ce mois → cherche le dernier mois connu
      final dernieresCotis = await supabase
          .from(AppTables.cotisations)
          .select('${AppTables.colStatutCotis}, ${AppTables.colAnnee}, ${AppTables.colMois}')
          .eq(AppTables.colMilitantId, militantId)
          .order(AppTables.colAnnee, ascending: false)
          .order(AppTables.colMois, ascending: false)
          .limit(1);

      if (dernieresCotis.isNotEmpty) {
        final sc = dernieresCotis.first[AppTables.colStatutCotis] as String;
        if (sc == AppEnums.cotisationEnRetard || sc == AppEnums.cotisationEnAttente) {
          final a = dernieresCotis.first[AppTables.colAnnee] as int;
          final mo = dernieresCotis.first[AppTables.colMois] as int;
          return ResultatScan.retard(
            nom: nom, prenom: prenom, numeroCarte: carte,
            periodeRetard: '${_nomMois(mo)} $a',
          );
        }
      }

      return ResultatScan.valide(nom: nom, prenom: prenom, numeroCarte: carte);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Scan] scannerCarte: $e\n$stack');
      throw const NetworkException();
    }
  }

  Future<void> enregistrerPresence({
    required String evenementId,
    required String militantId,
    required String nom,
    required String prenom,
  }) async {
    try {
      // Vérifie si déjà enregistré
      final existant = await supabase
          .from(AppTables.presences)
          .select(AppTables.colId)
          .eq(AppTables.colEvenementId, evenementId)
          .eq(AppTables.colMilitantId, militantId)
          .limit(1);

      if (existant.isNotEmpty) return;

      await supabase.from(AppTables.presences).insert({
        AppTables.colEvenementId: evenementId,
        AppTables.colMilitantId:  militantId,
        AppTables.colNom:         nom,
        AppTables.colPrenom:      prenom,
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Scan] enregistrerPresence: $e\n$stack');
      throw const NetworkException();
    }
  }

  static const _moisNoms = [
    '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];
  static String _nomMois(int m) => m >= 1 && m <= 12 ? _moisNoms[m] : '$m';
}