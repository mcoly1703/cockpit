import '../../domain/entities/candidat_election.dart';

class CandidatElectionModel {
  final String  id;
  final String  scrutinId;
  final String? militantId;
  final String  nom;
  final String  prenom;
  final String? poste;
  final int?    voix;
  final bool    elu;

  const CandidatElectionModel({
    required this.id,
    required this.scrutinId,
    this.militantId,
    required this.nom,
    required this.prenom,
    this.poste,
    this.voix,
    this.elu = false,
  });

  factory CandidatElectionModel.fromJson(Map<String, dynamic> json) => CandidatElectionModel(
    id:         json['id']          as String,
    scrutinId:  json['scrutin_id']  as String,
    militantId: json['militant_id'] as String?,
    nom:        json['nom']         as String,
    prenom:     json['prenom']      as String,
    poste:      json['poste']       as String?,
    voix:       json['voix']        as int?,
    elu:        (json['elu']        as bool?) ?? false,
  );

  CandidatElection toEntity() => CandidatElection(
    id:         id,
    scrutinId:  scrutinId,
    militantId: militantId,
    nom:        nom,
    prenom:     prenom,
    poste:      poste,
    voix:       voix,
    elu:        elu,
  );
}