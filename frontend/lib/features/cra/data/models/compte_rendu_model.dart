import '../../domain/entities/compte_rendu.dart';

class CompteRenduModel {
  final String  id;
  final String  uniteId;
  final String? uniteCode;
  final int     mois;
  final int     annee;
  final String  statut;
  final String  descriptionActivites;
  final int     nouveauxContacts;
  final int     evenementsTenus;
  final int     presencesTotal;
  final double  cotisationsCollectees;
  final String? difficultes;
  final String? observationsCoord;
  final String? soumisAt;
  final String? valideAt;
  final String  createdAt;

  const CompteRenduModel({
    required this.id,
    required this.uniteId,
    this.uniteCode,
    required this.mois,
    required this.annee,
    required this.statut,
    required this.descriptionActivites,
    required this.nouveauxContacts,
    required this.evenementsTenus,
    required this.presencesTotal,
    required this.cotisationsCollectees,
    this.difficultes,
    this.observationsCoord,
    this.soumisAt,
    this.valideAt,
    required this.createdAt,
  });

  factory CompteRenduModel.fromJson(Map<String, dynamic> json) {
    final uniteData = json['unites_organisationnelles'] as Map<String, dynamic>?;
    return CompteRenduModel(
      id:                    json['id']                     as String,
      uniteId:               json['unite_id']               as String,
      uniteCode:             uniteData?['code']             as String?,
      mois:                  json['mois']                   as int,
      annee:                 json['annee']                  as int,
      statut:                json['statut']                 as String,
      descriptionActivites:  json['description_activites']  as String,
      nouveauxContacts:      json['nouveaux_contacts']      as int,
      evenementsTenus:       json['evenements_tenus']       as int,
      presencesTotal:        json['presences_total']        as int,
      cotisationsCollectees: (json['cotisations_collectees'] as num).toDouble(),
      difficultes:           json['difficultes']            as String?,
      observationsCoord:     json['observations_coord']     as String?,
      soumisAt:              json['soumis_at']              as String?,
      valideAt:              json['valide_at']              as String?,
      createdAt:             json['created_at']             as String,
    );
  }

  CompteRendu toEntity() => CompteRendu(
    id:                    id,
    uniteId:               uniteId,
    uniteCode:             uniteCode,
    mois:                  mois,
    annee:                 annee,
    statut:                statut,
    descriptionActivites:  descriptionActivites,
    nouveauxContacts:      nouveauxContacts,
    evenementsTenus:       evenementsTenus,
    presencesTotal:        presencesTotal,
    cotisationsCollectees: cotisationsCollectees,
    difficultes:           difficultes,
    observationsCoord:     observationsCoord,
    soumisAt:              soumisAt  != null ? DateTime.parse(soumisAt!)  : null,
    valideAt:              valideAt  != null ? DateTime.parse(valideAt!)  : null,
    createdAt:             DateTime.parse(createdAt),
  );
}