import '../../domain/entities/utilisateur.dart';

class UtilisateurModel extends Utilisateur {
  const UtilisateurModel({
    required super.id,
    required super.email,
    required super.nom,
    required super.prenom,
    required super.role,
    super.uniteOrganisationnelleId,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id:                        json['id'] as String,
      email:                     json['email'] as String,
      nom:                       json['nom'] as String,
      prenom:                    json['prenom'] as String,
      role:                      json['role'] as String,
      uniteOrganisationnelleId:  json['unite_organisationnelle_id'] as String?,
    );
  }
}
