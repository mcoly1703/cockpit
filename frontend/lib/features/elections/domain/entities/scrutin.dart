import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrutin.freezed.dart';

@freezed
class Scrutin with _$Scrutin {
  const factory Scrutin({
    required String   id,
    String?           uniteId,
    required String   titre,
    required String   type,
    required DateTime dateScrutin,
    String?           description,
    required String   statut,
  }) = _Scrutin;
}