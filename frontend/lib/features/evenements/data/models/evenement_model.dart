import '../../domain/entities/evenement.dart';

class EvenementModel {
  final String   id;
  final String   titre;
  final String?  description;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final String   lieu;
  final String   type;
  final String   uniteId;
  final String   createdBy;
  final DateTime createdAt;

  const EvenementModel({
    required this.id,
    required this.titre,
    this.description,
    required this.dateDebut,
    this.dateFin,
    required this.lieu,
    required this.type,
    required this.uniteId,
    required this.createdBy,
    required this.createdAt,
  });

  factory EvenementModel.fromJson(Map<String, dynamic> j) => EvenementModel(
        id:          j['id'] as String,
        titre:       j['titre'] as String,
        description: j['description'] as String?,
        dateDebut:   DateTime.parse(j['date_debut'] as String),
        dateFin:     j['date_fin'] != null ? DateTime.parse(j['date_fin'] as String) : null,
        lieu:        j['lieu'] as String,
        type:        j['type'] as String,
        uniteId:     j['unite_id'] as String,
        createdBy:   j['created_by'] as String,
        createdAt:   DateTime.parse(j['created_at'] as String),
      );

  Evenement toEntity() => Evenement(
        id:          id,
        titre:       titre,
        description: description,
        dateDebut:   dateDebut,
        dateFin:     dateFin,
        lieu:        lieu,
        type:        type,
        uniteId:     uniteId,
        createdBy:   createdBy,
        createdAt:   createdAt,
      );
}