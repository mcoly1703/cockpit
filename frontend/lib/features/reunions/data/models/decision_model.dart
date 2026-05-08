import '../../domain/entities/decision.dart';

class DecisionModel {
  final String    id;
  final String    reunionId;
  final String    texte;
  final String?   responsable;
  final DateTime? echeance;
  final String    statut;
  final DateTime  createdAt;

  const DecisionModel({
    required this.id,
    required this.reunionId,
    required this.texte,
    this.responsable,
    this.echeance,
    required this.statut,
    required this.createdAt,
  });

  factory DecisionModel.fromJson(Map<String, dynamic> j) => DecisionModel(
        id:          j['id'] as String,
        reunionId:   j['reunion_id'] as String,
        texte:       j['texte'] as String,
        responsable: j['responsable'] as String?,
        echeance:    j['echeance'] != null ? DateTime.parse(j['echeance'] as String) : null,
        statut:      j['statut'] as String,
        createdAt:   DateTime.parse(j['created_at'] as String),
      );

  Decision toEntity() => Decision(
        id:          id,
        reunionId:   reunionId,
        texte:       texte,
        responsable: responsable,
        echeance:    echeance,
        statut:      statut,
        createdAt:   createdAt,
      );
}