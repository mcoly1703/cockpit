import '../../domain/entities/presence.dart';

class PresenceModel {
  final String   id;
  final String   evenementId;
  final String?  militantId;
  final String   nom;
  final String   prenom;
  final String?  telephone;
  final DateTime checkedAt;

  const PresenceModel({
    required this.id,
    required this.evenementId,
    this.militantId,
    required this.nom,
    required this.prenom,
    this.telephone,
    required this.checkedAt,
  });

  factory PresenceModel.fromJson(Map<String, dynamic> j) => PresenceModel(
        id:          j['id'] as String,
        evenementId: j['evenement_id'] as String,
        militantId:  j['militant_id'] as String?,
        nom:         j['nom'] as String,
        prenom:      j['prenom'] as String,
        telephone:   j['telephone'] as String?,
        checkedAt:   DateTime.parse(j['checked_at'] as String),
      );

  Presence toEntity() => Presence(
        id:          id,
        evenementId: evenementId,
        militantId:  militantId,
        nom:         nom,
        prenom:      prenom,
        telephone:   telephone,
        checkedAt:   checkedAt,
      );
}