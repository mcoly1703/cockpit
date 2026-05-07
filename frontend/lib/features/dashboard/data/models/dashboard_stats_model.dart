import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel {
  static DashboardStats fromSupabase({
    required Map<String, dynamic> militants,
    required Map<String, dynamic> finances,
    required Map<String, dynamic> activite,
    required List<Map<String, dynamic>> evolutionMilitantsRaw,
    required List<Map<String, dynamic>> evolutionFinancesRaw,
  }) {
    return DashboardStats(
      // Militants
      totalMilitants:    militants['total'] as int? ?? 0,
      nouveauxCeMois:    militants['nouveaux_ce_mois'] as int? ?? 0,
      objectifMilitants: AppConstants.objectifMilitants,
      pourcentageHommes: (militants['pct_hommes'] as num?)?.toDouble() ?? 0,
      pourcentageFemmes: (militants['pct_femmes'] as num?)?.toDouble() ?? 0,
      evolutionMilitants: evolutionMilitantsRaw
          .map((e) => PointGraphique(
                mois:   DateTime.parse(e['mois'] as String),
                valeur: (e['total'] as num).toDouble(),
              ))
          .toList(),

      // Finances
      soldeGlobal:          (finances['solde'] as num?)?.toDouble() ?? 0,
      tauxRecouvrement:     (finances['taux_recouvrement'] as num?)?.toDouble() ?? 0,
      objectifRecouvrement: AppConstants.objectifRecouvrement,
      evolutionFinances:    evolutionFinancesRaw
          .map((e) => PointGraphique(
                mois:   DateTime.parse(e['mois'] as String),
                valeur: (e['solde'] as num).toDouble(),
              ))
          .toList(),

      // Militants (complément)
      nouveauxCetteAnnee: militants['nouveaux_cette_annee'] as int? ?? 0,

      // Finances (complément)
      totalEntrees: (finances['total_entrees'] as num?)?.toDouble() ?? 0,

      // Activité
      prospectsActifs:    activite['prospects_actifs'] as int? ?? 0,
      tauxConversion:     (activite['taux_conversion'] as num?)?.toDouble() ?? 0,
      evenementsCeMois:   activite['evenements_ce_mois'] as int? ?? 0,
      evenementsAVenir:   activite['evenements_a_venir'] as int? ?? 0,
      decisionsEnAttente: activite['decisions_en_attente'] as int? ?? 0,
      actionsEnRetard:    activite['actions_en_retard'] as int? ?? 0,

      // Structure
      nombreCellules: activite['nombre_cellules'] as int? ?? 0,
    );
  }
}