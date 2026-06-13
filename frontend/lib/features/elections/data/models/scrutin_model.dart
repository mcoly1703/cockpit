import '../../domain/entities/scrutin.dart';

class ScrutinModel {
  final String  id;
  final String? uniteId;
  final String  titre;
  final String  type;
  final String  dateScrutin;
  final String? description;
  final String  statut;

  const ScrutinModel({
    required this.id,
    this.uniteId,
    required this.titre,
    required this.type,
    required this.dateScrutin,
    this.description,
    required this.statut,
  });

  factory ScrutinModel.fromJson(Map<String, dynamic> json) => ScrutinModel(
    id:          json['id']           as String,
    uniteId:     json['unite_id']     as String?,
    titre:       json['titre']        as String,
    type:        json['type']         as String,
    dateScrutin: json['date_scrutin'] as String,
    description: json['description']  as String?,
    statut:      json['statut']       as String,
  );

  Scrutin toEntity() => Scrutin(
    id:          id,
    uniteId:     uniteId,
    titre:       titre,
    type:        type,
    dateScrutin: DateTime.parse(dateScrutin),
    description: description,
    statut:      statut,
  );
}