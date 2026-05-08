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

  // Table unites_organisationnelles
  static const String unitesOrganisationnelles = 'unites_organisationnelles';
  static const String colCode      = 'code';
  static const String colParentId  = 'parent_id';

  // Colonnes militants
  static const String colSexe         = 'sexe';
  static const String colStatut       = 'statut';
  static const String colDateAdhesion = 'date_adhesion';
  static const String colNumeroCarte  = 'numero_carte';
  static const String colDateNaissance = 'date_naissance';
  static const String colTelephone    = 'telephone';
  static const String colVille        = 'ville';
  static const String colCodePostal   = 'code_postal';
  static const String colPhotoUrl     = 'photo_url';
  static const String colCreatedBy    = 'created_by';

  // Colonnes transactions
  static const String colType                   = 'type';
  static const String colMontant                = 'montant';
  static const String colDateTransaction        = 'date_transaction';
  static const String colCategorie              = 'categorie';
  static const String colDescription            = 'description';
  static const String colBeneficiaire           = 'beneficiaire';
  static const String colPieceJustificativeUrl  = 'piece_justificative_url';

  // Colonnes cotisations
  static const String colAnnee          = 'annee';
  static const String colStatutCotis    = 'statut';
  static const String colMilitantId     = 'militant_id';
  static const String colDatePaiement   = 'date_paiement';
  static const String colTransactionId  = 'transaction_id';
}

/// Types d'unités organisationnelles (enum unite_type en base).
class AppUniteTypes {
  static const String bureauExecutif = 'bureau_executif';
  static const String sousSection    = 'sous_section';
  static const String mouvement      = 'mouvement';
  static const String secretariat    = 'secretariat';
  static const String cellule        = 'cellule';
}

/// Rôles Pastef France (enum user_role en base).
class AppRoles {
  static const String bureauExecutif         = 'bureau_executif';
  static const String coordinateur           = 'coordinateur';
  static const String responsableSousSection = 'responsable_sous_section';
  static const String responsableMouvement   = 'responsable_mouvement';
  static const String responsableSecretariat = 'responsable_secretariat';
  static const String coordinateurCellule    = 'coordinateur_cellule';
  static const String adminTechnique         = 'admin_technique';
}

/// Rôles MonCap Diaspora (enum user_role en base, préfixe moncap_).
class AppRolesMoncap {
  static const String coordo             = 'moncap_coordo';
  static const String coordoAdj          = 'moncap_coordo_adj';
  static const String secretaire         = 'moncap_secretaire';
  static const String secretaireAdj      = 'moncap_secretaire_adj';
  static const String respMassification  = 'moncap_resp_massification';
  static const String adjMassification   = 'moncap_adj_massification';
  static const String respCommunication  = 'moncap_resp_communication';
  static const String adjCommunication   = 'moncap_adj_communication';
  static const String respFinance        = 'moncap_resp_finance';
  static const String adjFinance         = 'moncap_adj_finance';
  static const String respOrganisation   = 'moncap_resp_organisation';
  static const String adjOrganisation    = 'moncap_adj_organisation';
  static const String respScientifique   = 'moncap_resp_scientifique';
  static const String adjScientifique    = 'moncap_adj_scientifique';
  static const String respCommission     = 'moncap_resp_commission';
  static const String adjCommission      = 'moncap_adj_commission';

  /// Retourne true si le rôle a accès à la plateforme.
  /// Règle : coordo/adj, secrétaire/adj, resp+adj pôles, resp+adj commissions → accès.
  /// Membres simples des commissions → pas de rôle moncap_, donc exclus automatiquement.
  static bool aAcces(String role) => role.startsWith('moncap_');
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
  static const String transactionDepense = 'depense';

  // statut_cotisation
  static const String cotisationPayee     = 'payee';
  static const String cotisationEnAttente = 'en_attente';
  static const String cotisationEnRetard  = 'en_retard';
}

/// Catégories financières (enum categorie_finance en base).
class AppCategories {
  // Entrées
  static const String cotisation    = 'cotisation';
  static const String don           = 'don';
  static const String beneficeEvent = 'benefice_event';
  static const String goodiesVente  = 'goodies_vente';

  // Dépenses
  static const String logistique    = 'logistique';
  static const String communication = 'communication';
  static const String materiel      = 'materiel';
  static const String deplacements  = 'deplacements';
  static const String goodiesAchat  = 'goodies_achat';
  static const String administration = 'administration';
  static const String formation     = 'formation';

  static const List<String> entrees = [cotisation, don, beneficeEvent, goodiesVente];
  static const List<String> depenses = [logistique, communication, materiel, deplacements, goodiesAchat, administration, formation];

  static String label(String cat) => switch (cat) {
    cotisation    => 'Cotisations',
    don           => 'Dons',
    beneficeEvent => 'Bénéfices événements',
    goodiesVente  => 'Vente goodies',
    logistique    => 'Logistique',
    communication => 'Communication',
    materiel      => 'Matériel',
    deplacements  => 'Déplacements',
    goodiesAchat  => 'Achat goodies',
    administration => 'Administration',
    formation     => 'Formation',
    _             => cat,
  };
}
