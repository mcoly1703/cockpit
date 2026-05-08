import 'package:freezed_annotation/freezed_annotation.dart';

part 'decision.freezed.dart';

@freezed
class Decision with _$Decision {
  const factory Decision({
    required String   id,
    required String   reunionId,
    required String   texte,
    String?           responsable,
    DateTime?         echeance,
    required String   statut,
    required DateTime createdAt,
  }) = _Decision;
}