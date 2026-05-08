import 'package:freezed_annotation/freezed_annotation.dart';

part 'evenement.freezed.dart';

@freezed
class Evenement with _$Evenement {
  const factory Evenement({
    required String   id,
    required String   titre,
    String?           description,
    required DateTime dateDebut,
    DateTime?         dateFin,
    required String   lieu,
    required String   type,
    required String   uniteId,
    required String   createdBy,
    required DateTime createdAt,
  }) = _Evenement;
}