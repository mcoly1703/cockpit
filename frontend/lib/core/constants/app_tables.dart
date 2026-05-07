/// Noms des tables Supabase et de leurs colonnes.
/// Toute référence à la base de données passe par ces constantes.
class AppTables {
  // Tables
  static const String profiles          = 'profiles';
  static const String adminsTechniques  = 'admins_techniques';
  static const String militants         = 'militants';
  static const String transactions      = 'transactions';
  static const String cotisations       = 'cotisations';

  // Colonnes communes
  static const String colId        = 'id';
  static const String colEmail     = 'email';
  static const String colNom       = 'nom';
  static const String colPrenom    = 'prenom';
  static const String colRole      = 'role';
  static const String colIsActive  = 'is_active';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colUniteId   = 'unite_id';

  // Colonnes profiles
  static const String colUniteOrganisationnelleId = 'unite_organisationnelle_id';
  static const String colEntite                   = 'entite';

  // Colonnes militants
  static const String colSexe         = 'sexe';
  static const String colStatut       = 'statut';
  static const String colDateAdhesion = 'date_adhesion';

  // Colonnes transactions
  static const String colType             = 'type';
  static const String colMontant          = 'montant';
  static const String colDateTransaction  = 'date_transaction';

  // Colonnes cotisations
  static const String colAnnee          = 'annee';
  static const String colStatutCotis    = 'statut';
  static const String colMilitantId     = 'militant_id';
}

/// Valeurs des rôles utilisateurs (enum user_role en base).
class AppRoles {
  static const String bureauExecutif         = 'bureau_executif';
  static const String coordinateur           = 'coordinateur';
  static const String responsableSousSection = 'responsable_sous_section';
  static const String responsableMouvement   = 'responsable_mouvement';
  static const String responsableSecretariat = 'responsable_secretariat';
  static const String coordinateurCellule    = 'coordinateur_cellule';
  static const String adminTechnique         = 'admin_technique';
}

/// Identifiants des deux entités de la plateforme.
class AppEntites {
  static const String pastef  = 'pastef_france';
  static const String moncap  = 'moncap_diaspora';
}

/// Valeurs des enums Supabase.
class AppEnums {
  // statut_militant
  static const String militantActif    = 'actif';
  static const String militantInactif  = 'inactif';
  static const String militantSuspendu = 'suspendu';

  // sexe_type
  static const String sexeHomme  = 'M';
  static const String sexeFemme  = 'F';
  static const String sexeAutre  = 'autre';

  // transaction_type
  static const String transactionEntree  = 'entree';
  static const String transactionSortie  = 'sortie';

  // statut_cotisation
  static const String cotisationPayee      = 'payee';
  static const String cotisationEnAttente  = 'en_attente';
  static const String cotisationAnnulee    = 'annulee';
}
