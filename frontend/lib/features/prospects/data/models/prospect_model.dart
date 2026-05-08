import '../../domain/entities/prospect.dart';

class ProspectModel {
  final String    id;
  final String    nom;
  final String    prenom;
  final String    telephone;
  final String?   email;
  final String    ville;
  final String?   sexe;
  final String?   mouvementInteret;
  final String    etape;
  final DateTime  dateContact;
  final String?   notes;
  final String    uniteId;
  final String?   convertiEnMilitantId;
  final DateTime  createdAt;

  const ProspectModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    required this.ville,
    this.sexe,
    this.mouvementInteret,
    required this.etape,
    required this.dateContact,
    this.notes,
    required this.uniteId,
    this.convertiEnMilitantId,
    required this.createdAt,
  });

  factory ProspectModel.fromJson(Map<String, dynamic> j) => ProspectModel(
        id:                   j['id'] as String,
        nom:                  j['nom'] as String,
        prenom:               j['prenom'] as String,
        telephone:            j['telephone'] as String,
        email:                j['email'] as String?,
        ville:                j['ville'] as String,
        sexe:                 j['sexe'] as String?,
        mouvementInteret:     j['mouvement_interet'] as String?,
        etape:                j['etape'] as String,
        dateContact:          DateTime.parse(j['date_contact'] as String),
        notes:                j['notes'] as String?,
        uniteId:              j['unite_id'] as String,
        convertiEnMilitantId: j['converti_en_militant_id'] as String?,
        createdAt:            DateTime.parse(j['created_at'] as String),
      );

  Prospect toEntity() => Prospect(
        id:                   id,
        nom:                  nom,
        prenom:               prenom,
        telephone:            telephone,
        email:                email,
        ville:                ville,
        sexe:                 sexe,
        mouvementInteret:     mouvementInteret,
        etape:                etape,
        dateContact:          dateContact,
        notes:                notes,
        uniteId:              uniteId,
        convertiEnMilitantId: convertiEnMilitantId,
        createdAt:            createdAt,
      );
}