import '../../domain/entities/militant.dart';

class MilitantModel {
  final String id;
  final String numeroCarte;
  final String nom;
  final String prenom;
  final DateTime? dateNaissance;
  final String? sexe;
  final String? telephone;
  final String? email;
  final String? ville;
  final String? codePostal;
  final String uniteId;
  final String statut;
  final DateTime dateAdhesion;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MilitantModel({
    required this.id,
    required this.numeroCarte,
    required this.nom,
    required this.prenom,
    this.dateNaissance,
    this.sexe,
    this.telephone,
    this.email,
    this.ville,
    this.codePostal,
    required this.uniteId,
    required this.statut,
    required this.dateAdhesion,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MilitantModel.fromJson(Map<String, dynamic> json) => MilitantModel(
        id:            json['id'] as String,
        numeroCarte:   json['numero_carte'] as String,
        nom:           json['nom'] as String,
        prenom:        json['prenom'] as String,
        dateNaissance: json['date_naissance'] != null
            ? DateTime.parse(json['date_naissance'] as String)
            : null,
        sexe:          json['sexe'] as String?,
        telephone:     json['telephone'] as String?,
        email:         json['email'] as String?,
        ville:         json['ville'] as String?,
        codePostal:    json['code_postal'] as String?,
        uniteId:       json['unite_id'] as String,
        statut:        json['statut'] as String,
        dateAdhesion:  DateTime.parse(json['date_adhesion'] as String),
        photoUrl:      json['photo_url'] as String?,
        createdAt:     DateTime.parse(json['created_at'] as String),
        updatedAt:     DateTime.parse(json['updated_at'] as String),
      );

  Militant toEntity() => Militant(
        id:            id,
        numeroCarte:   numeroCarte,
        nom:           nom,
        prenom:        prenom,
        dateNaissance: dateNaissance,
        sexe:          sexe,
        telephone:     telephone,
        email:         email,
        ville:         ville,
        codePostal:    codePostal,
        uniteId:       uniteId,
        statut:        statut,
        dateAdhesion:  dateAdhesion,
        photoUrl:      photoUrl,
        createdAt:     createdAt,
        updatedAt:     updatedAt,
      );
}