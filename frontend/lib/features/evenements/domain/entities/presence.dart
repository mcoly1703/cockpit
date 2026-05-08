import 'package:freezed_annotation/freezed_annotation.dart';

part 'presence.freezed.dart';

@freezed
class Presence with _$Presence {
  const factory Presence({
    required String   id,
    required String   evenementId,
    String?           militantId,
    required String   nom,
    required String   prenom,
    String?           telephone,
    required DateTime checkedAt,
  }) = _Presence;
}