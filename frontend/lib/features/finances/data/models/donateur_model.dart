import '../../domain/entities/donateur.dart';

class DonateurModel {
  final String id;
  final String nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String? ville;

  const DonateurModel({
    required this.id,
    required this.nom,
    this.prenom,
    this.telephone,
    this.email,
    this.ville,
  });

  factory DonateurModel.fromJson(Map<String, dynamic> j) => DonateurModel(
        id:        j['id'] as String,
        nom:       j['nom'] as String,
        prenom:    j['prenom'] as String?,
        telephone: j['telephone'] as String?,
        email:     j['email'] as String?,
        ville:     j['ville'] as String?,
      );

  Donateur toEntity() => Donateur(
        id:        id,
        nom:       nom,
        prenom:    prenom,
        telephone: telephone,
        email:     email,
        ville:     ville,
      );
}
