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
  static const String colMois           = 'mois';
  static const String colMontantPaye    = 'montant_paye';
  static const String colMontantDu      = 'montant_du';
  static const String colModePaiement   = 'mode_paiement';
  static const String colStatutCotis    = 'statut';
  static const String colMilitantId     = 'militant_id';
  static const String colDatePaiement   = 'date_paiement';
  static const String colTransactionId  = 'transaction_id';

  // Colonnes militants (nouvelles)
  static const String colMouvementId    = 'mouvement_id';
  static const String colStatutCarte    = 'statut_carte';

  // Table reunions
  static const String reunions         = 'reunions';
  static const String decisions        = 'decisions';
  static const String colDate           = 'date';
  static const String colOrdreJour     = 'ordre_du_jour';
  static const String colReunionId     = 'reunion_id';
  static const String colTexte         = 'texte';
  static const String colResponsable   = 'responsable';
  static const String colEcheance      = 'echeance';

  // Table evenements
  static const String evenements             = 'evenements';
  static const String presences              = 'presences';
  static const String colTitre              = 'titre';
  static const String colDateDebut          = 'date_debut';
  static const String colDateFin            = 'date_fin';
  static const String colLieu               = 'lieu';
  static const String colEvenementId        = 'evenement_id';
  static const String colCheckedAt          = 'checked_at';

  // Table prospects
  static const String prospects               = 'prospects';
  static const String colEtape               = 'etape';
  static const String colDateContact         = 'date_contact';
  static const String colMouvementInteret    = 'mouvement_interet';
  static const String colNotes               = 'notes';
  static const String colConvertiMilitantId  = 'converti_en_militant_id';

  // Table postes_bureau
  static const String postesBureau      = 'postes_bureau';
  static const String colIntitule       = 'intitule';
  static const String colDateNomination = 'date_nomination';
  static const String colMilitantNom    = 'militant_nom';
  static const String colMilitantPrenom = 'militant_prenom';

  // Tables élections
  static const String scrutins          = 'scrutins';
  static const String candidatsElection = 'candidats_election';
  static const String colScrutinId      = 'scrutin_id';
  static const String colDateScrutin    = 'date_scrutin';
  static const String colPoste          = 'poste';
  static const String colVoix           = 'voix';
  static const String colElu            = 'elu';

  // Table CRA
  static const String compteRendus               = 'comptes_rendus';
  static const String colDescriptionActivites    = 'description_activites';
  static const String colNouveauxContacts        = 'nouveaux_contacts';
  static const String colEvenementsTenus         = 'evenements_tenus';
  static const String colPresencesTotal          = 'presences_total';
  static const String colCotisationsCollectees   = 'cotisations_collectees';
  static const String colDifficultes             = 'difficultes';
  static const String colObservationsCoord       = 'observations_coordinateur';
  static const String colSoumisAt               = 'soumis_at';
  static const String colValideAt               = 'valide_at';
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
  static const String cotisationPartiel   = 'partiel';
  static const String cotisationEnAttente = 'en_attente';
  static const String cotisationEnRetard  = 'en_retard';

  // statut_carte
  static const String carteActive    = 'active';
  static const String carteExpiree   = 'expiree';
  static const String cartePerdue    = 'perdue';
  static const String carteEnAttente = 'en_attente';

  // type_reunion
  static const String typeReunionBureau           = 'bureau';
  static const String typeReunionCellule          = 'cellule';
  static const String typeReunionSousSection      = 'sous_section';
  static const String typeReunionCommission       = 'commission';
  static const String typeReunionAssembleeGen     = 'assemblee_generale';
  static const String typeReunionAutre            = 'autre';

  static const List<(String, String)> typesReunion = [
    (typeReunionBureau,       'Bureau'),
    (typeReunionCellule,      'Cellule'),
    (typeReunionSousSection,  'Sous-section'),
    (typeReunionCommission,   'Commission'),
    (typeReunionAssembleeGen, 'Assemblée générale'),
    (typeReunionAutre,        'Autre'),
  ];

  // statut_decision
  static const String decisionEnAttente = 'en_attente';
  static const String decisionEnCours   = 'en_cours';
  static const String decisionTerminee  = 'terminee';
  static const String decisionAbandon   = 'abandonnee';

  // type_evenement
  static const String typeReunionPublique = 'reunion_publique';
  static const String typeMeeting         = 'meeting';
  static const String typeMarche          = 'marche';
  static const String typeFormation       = 'formation';
  static const String typePorteAPorte     = 'porte_a_porte';
  static const String typeAutre           = 'autre';

  static const List<(String, String)> typesEvenement = [
    (typeReunionPublique, 'Réunion publique'),
    (typeMeeting,         'Meeting'),
    (typeMarche,          'Marche'),
    (typeFormation,       'Formation'),
    (typePorteAPorte,     'Porte à porte'),
    (typeAutre,           'Autre'),
  ];

  // etape_prospect
  static const String etapeContact      = 'contact';
  static const String etapeSympathisant = 'sympathisant';
  static const String etapeAdherent     = 'adherent';
  static const String etapeConverti     = 'converti';

  static const List<String> etapesProspect = [
    etapeContact,
    etapeSympathisant,
    etapeAdherent,
    etapeConverti,
  ];

  // Postes Bureau Exécutif (16 postes)
  static const List<(String, String)> postesExecutif = [
    ('coordinateur',         'Coordinateur/trice'),
    ('coordinateur_adj',     'Adjoint(e) Coordinateur'),
    ('resp_finances',        'Resp. Finances'),
    ('vice_finances',        'Vice-Resp. Finances'),
    ('resp_massification',   'Resp. Massification'),
    ('vice_massification',   'Vice-Resp. Massification'),
    ('resp_it',              'Resp. IT'),
    ('vice_it',              'Vice-Resp. IT'),
    ('resp_communication',   'Resp. Communication'),
    ('vice_communication',   'Vice-Resp. Communication'),
    ('resp_veille',          'Resp. Veille Électorale'),
    ('vice_veille',          'Vice-Resp. Veille Électorale'),
    ('resp_formation',       'Resp. Formation'),
    ('vice_formation',       'Vice-Resp. Formation'),
    ('resp_organisation',    'Resp. Organisation'),
    ('vice_organisation',    'Vice-Resp. Organisation'),
  ];

  // statut_cra
  static const String craBrouillon = 'brouillon';
  static const String craSoumis    = 'soumis';
  static const String craValide    = 'valide';
  static const String craRetourne  = 'retourne';

  // type_scrutin
  static const String scrutinInterne    = 'interne';
  static const String scrutinMunicipal  = 'municipal';
  static const String scrutinLegislatif = 'legislatif';
  static const String scrutinEuropeen   = 'europeen';
  static const String scrutinAutre      = 'autre';

  static const List<(String, String)> typesScrutin = [
    (scrutinInterne,    'Interne'),
    (scrutinMunicipal,  'Municipal'),
    (scrutinLegislatif, 'Législatif'),
    (scrutinEuropeen,   'Européen'),
    (scrutinAutre,      'Autre'),
  ];

  // statut_scrutin
  static const String scrutinEnPreparation = 'en_preparation';
  static const String scrutinOuvert        = 'ouvert';
  static const String scrutinClos          = 'clos';

  // Postes bureaux locaux : Sous-sections, Mouvements, Cellules (18 postes)
  static const List<(String, String)> postesLocaux = [
    ('coordinateur',         'Coordinateur/trice'),
    ('vice_coordinateur',    'Vice-Coordinateur/trice'),
    ('resp_communication',   'Resp. Communication'),
    ('vice_communication',   'Vice-Resp. Communication'),
    ('resp_finances',        'Resp. Finances'),
    ('vice_finances',        'Vice-Resp. Finances'),
    ('resp_massification',   'Resp. Massification'),
    ('vice_massification',   'Vice-Resp. Massification'),
    ('resp_veille',          'Resp. Veille Électorale'),
    ('vice_veille',          'Vice-Resp. Veille Électorale'),
    ('resp_organisation',    'Resp. Organisation'),
    ('vice_organisation',    'Vice-Resp. Organisation'),
    ('resp_formation',       'Resp. Formation'),
    ('vice_formation',       'Vice-Resp. Formation'),
    ('resp_mojip',           'Resp. MOJIP'),
    ('resp_jps',             'Resp. JPS'),
    ('resp_maggi',           'Resp. Maggi Pastef'),
    ('resp_foyer',           'Resp. Foyer'),
  ];
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
