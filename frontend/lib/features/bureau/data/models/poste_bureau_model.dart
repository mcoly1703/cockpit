import '../../domain/entities/poste_bureau.dart';

class PosteBureauModel {
  final String   id;
  final String   uniteId;
  final String   intitule;
  final String   militantId;
  final String   militantNom;
  final String   militantPrenom;
  final DateTime dateNomination;
  final String   createdBy;
  final DateTime createdAt;

  const PosteBureauModel({
    required this.id,
    required this.uniteId,
    required this.intitule,
    required this.militantId,
    required this.militantNom,
    required this.militantPrenom,
    required this.dateNomination,
    required this.createdBy,
    required this.createdAt,
  });

  factory PosteBureauModel.fromJson(Map<String, dynamic> json) {
    final militant = json['militants'] as Map<String, dynamic>?;
    return PosteBureauModel(
      id:              json['id'] as String,
      uniteId:         json['unite_id'] as String,
      intitule:        json['intitule'] as String,
      militantId:      json['militant_id'] as String,
      militantNom:     militant?['nom'] as String? ?? '',
      militantPrenom:  militant?['prenom'] as String? ?? '',
      dateNomination:  DateTime.parse(json['date_nomination'] as String),
      createdBy:       json['created_by'] as String,
      createdAt:       DateTime.parse(json['created_at'] as String),
    );
  }

  PosteBureau toEntity() => PosteBureau(
        id:              id,
        uniteId:         uniteId,
        intitule:        intitule,
        militantId:      militantId,
        militantNom:     militantNom,
        militantPrenom:  militantPrenom,
        dateNomination:  dateNomination,
        createdBy:       createdBy,
        createdAt:       createdAt,
      );
}