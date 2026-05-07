/// Noms des tables Supabase et de leurs colonnes.
/// Toute référence à la base de données passe par ces constantes.
class AppTables {
  // Tables
  static const String profiles          = 'profiles';
  static const String adminsTechniques  = 'admins_techniques';

  // Colonnes communes
  static const String colId        = 'id';
  static const String colEmail     = 'email';
  static const String colNom       = 'nom';
  static const String colPrenom    = 'prenom';
  static const String colRole      = 'role';
  static const String colIsActive  = 'is_active';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  // Colonnes spécifiques profiles
  static const String colUniteOrganisationnelleId = 'unite_organisationnelle_id';
}

/// Valeurs des rôles utilisateurs.
class AppRoles {
  static const String bureauExecutif          = 'bureau_executif';
  static const String coordinateur            = 'coordinateur';
  static const String responsableSousSection  = 'responsable_sous_section';
  static const String responsableMouvement    = 'responsable_mouvement';
  static const String responsableSecretariat  = 'responsable_secretariat';
  static const String coordinateurCellule     = 'coordinateur_cellule';
  static const String adminTechnique          = 'admin_technique';
}