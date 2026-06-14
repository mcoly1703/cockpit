/// Constantes métier de l'application.
/// Objectifs, seuils et valeurs de référence définis par le bureau exécutif.
class AppConstants {
  // Objectifs militants
  static const int objectifMilitants        = 10000;

  // Objectifs finances
  static const double objectifRecouvrement  = 80.0;

  // Graphiques
  static const int nombreMoisGraphique      = 6;   // dashboard + militants
  static const int nombreMoisGraphiqueAnnuel = 12; // finances

  // Seuils d'objectif minimum par type d'unité (pour le calcul proportionnel)
  static const int objectifMinSousSection   = 10;
  static const int objectifMinCellule       = 5;

  // Seuils de statut d'une cellule
  static const int seuilActiveCellule       = 25;  // active à partir de 25 membres
  static const int seuilPleineCellule       = 100; // pleine à partir de 100 membres

  // Limites d'affichage dans les listes de stats
  static const int maxLignesStats           = 10;
  static const int maxLignesCellules        = 15;

  // Dates limites pour le formulaire militant
  static final DateTime premiereDateNaissance = DateTime(1940);
  static final DateTime premiereAdhesion      = DateTime(2000);
}