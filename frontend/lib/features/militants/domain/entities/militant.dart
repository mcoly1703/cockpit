import 'package:freezed_annotation/freezed_annotation.dart';

part 'militant.freezed.dart';

@freezed
class Militant with _$Militant {
  const factory Militant({
    required String id,
    required String numeroCarte,
    required String nom,
    required String prenom,
    DateTime? dateNaissance,
    String? sexe,
    String? telephone,
    String? email,
    String? ville,
    String? codePostal,
    required String uniteId,
    String? mouvementId,
    required String statut,
    @Default('en_attente') String statutCarte,
    required DateTime dateAdhesion,
    String? photoUrl,
    String? parrainId,
    String? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Militant;
}