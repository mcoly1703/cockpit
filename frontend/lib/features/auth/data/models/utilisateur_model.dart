import '../../domain/entities/utilisateur.dart';

class UtilisateurModel {
  final String id;
  final String email;
  final String nom;
  final String prenom;
  final String role;
  final String? uniteOrganisationnelleId;

  const UtilisateurModel({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    this.uniteOrganisationnelleId,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id:                       json['id'] as String,
      email:                    json['email'] as String,
      nom:                      json['nom'] as String,
      prenom:                   json['prenom'] as String,
      role:                     json['role'] as String,
      uniteOrganisationnelleId: json['unite_organisationnelle_id'] as String?,
    );
  }

  // Convertit le modèle data en entité domain
  Utilisateur toEntity() {
    return Utilisateur(
      id:                       id,
      email:                    email,
      nom:                      nom,
      prenom:                   prenom,
      role:                     role,
      uniteOrganisationnelleId: uniteOrganisationnelleId,
    );
  }
}
