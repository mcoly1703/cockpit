import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

/// Un point de données sur un graphique mensuel
@freezed
class PointGraphique with _$PointGraphique {
  const factory PointGraphique({
    required DateTime mois,
    required double valeur,
  }) = _PointGraphique;
}

/// Toutes les données KPI du tableau de bord
@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    // --- Militants ---
    required int totalMilitants,
    required int nouveauxCeMois,
    required int objectifMilitants,
    required double pourcentageHommes,
    required double pourcentageFemmes,
    required List<PointGraphique> evolutionMilitants,

    // --- Finances ---
    required double soldeGlobal,
    required double tauxRecouvrement,
    required double objectifRecouvrement,
    required List<PointGraphique> evolutionFinances,

    // --- Activité ---
    required int prospectsActifs,
    required double tauxConversion,
    required int evenementsCeMois,
    required int decisionsEnAttente,
  }) = _DashboardStats;
}
