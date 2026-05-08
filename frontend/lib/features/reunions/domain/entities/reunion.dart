import 'package:freezed_annotation/freezed_annotation.dart';

part 'reunion.freezed.dart';

@freezed
class Reunion with _$Reunion {
  const factory Reunion({
    required String   id,
    required String   titre,
    required String   type,
    required DateTime date,
    required String   lieu,
    String?           ordreJour,
    required String   uniteId,
    required String   createdBy,
    required DateTime createdAt,
  }) = _Reunion;
}