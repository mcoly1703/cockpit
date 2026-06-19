import 'package:freezed_annotation/freezed_annotation.dart';

part 'prospect.freezed.dart';

@freezed
class Prospect with _$Prospect {
  const factory Prospect({
    required String id,
    required String nom,
    required String prenom,
    required String telephone,
    String?         email,
    required String ville,
    String?         sexe,
    String?         mouvementInteret,
    required String etape,
    required DateTime dateContact,
    String?         notes,
    required String uniteId,
    String?         convertiEnMilitantId,
    String?         createdByNom,
    required DateTime createdAt,
  }) = _Prospect;
}