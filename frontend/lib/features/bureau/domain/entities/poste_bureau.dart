import 'package:freezed_annotation/freezed_annotation.dart';

part 'poste_bureau.freezed.dart';

@freezed
class PosteBureau with _$PosteBureau {
  const factory PosteBureau({
    required String   id,
    required String   uniteId,
    required String   intitule,
    required String   militantId,
    required String   militantNom,
    required String   militantPrenom,
    required DateTime dateNomination,
    required String   createdBy,
    required DateTime createdAt,
  }) = _PosteBureau;
}

class MilitantResume {
  final String id;
  final String nom;
  final String prenom;
  const MilitantResume({required this.id, required this.nom, required this.prenom});
  String get nomComplet => '$prenom $nom';
}