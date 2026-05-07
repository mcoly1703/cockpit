import 'package:freezed_annotation/freezed_annotation.dart';

part 'utilisateur.freezed.dart';

@freezed
class Utilisateur with _$Utilisateur {
  const factory Utilisateur({
    required String id,
    required String email,
    required String nom,
    required String prenom,
    required String role,
    String? uniteOrganisationnelleId,
    String? entite,
  }) = _Utilisateur;
}
