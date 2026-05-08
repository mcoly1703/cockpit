import '../../domain/entities/reunion.dart';

class ReunionModel {
  final String   id;
  final String   titre;
  final String   type;
  final DateTime date;
  final String   lieu;
  final String?  ordreJour;
  final String   uniteId;
  final String   createdBy;
  final DateTime createdAt;

  const ReunionModel({
    required this.id,
    required this.titre,
    required this.type,
    required this.date,
    required this.lieu,
    this.ordreJour,
    required this.uniteId,
    required this.createdBy,
    required this.createdAt,
  });

  factory ReunionModel.fromJson(Map<String, dynamic> j) => ReunionModel(
        id:        j['id'] as String,
        titre:     j['titre'] as String,
        type:      j['type'] as String,
        date:      DateTime.parse(j['date'] as String),
        lieu:      j['lieu'] as String,
        ordreJour: j['ordre_du_jour'] as String?,
        uniteId:   j['unite_id'] as String,
        createdBy: j['created_by'] as String,
        createdAt: DateTime.parse(j['created_at'] as String),
      );

  Reunion toEntity() => Reunion(
        id:        id,
        titre:     titre,
        type:      type,
        date:      date,
        lieu:      lieu,
        ordreJour: ordreJour,
        uniteId:   uniteId,
        createdBy: createdBy,
        createdAt: createdAt,
      );
}