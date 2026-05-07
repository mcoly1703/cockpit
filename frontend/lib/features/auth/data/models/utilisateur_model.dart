import '../../../../core/constants/app_tables.dart';
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
      id:                       json[AppTables.colId]                       as String,
      email:                    json[AppTables.colEmail]                    as String,
      nom:                      json[AppTables.colNom]                      as String,
      prenom:                   json[AppTables.colPrenom]                   as String,
      role:                     json[AppTables.colRole]                     as String,
      uniteOrganisationnelleId: json[AppTables.colUniteOrganisationnelleId] as String?,
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
