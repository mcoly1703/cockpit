import 'package:freezed_annotation/freezed_annotation.dart';

part 'classement_entry.freezed.dart';

@freezed
class ClassementEntry with _$ClassementEntry {
  const factory ClassementEntry({
    required int rang,
    required String militantId,
    required String nom,
    required String prenom,
    String? uniteNom,
    required int score,
    String? detailLabel,
    @Default(false) bool estExterne,
  }) = _ClassementEntry;
}
