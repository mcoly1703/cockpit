import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidat_election.freezed.dart';

@freezed
class CandidatElection with _$CandidatElection {
  const CandidatElection._();

  const factory CandidatElection({
    required String id,
    required String scrutinId,
    String?         militantId,
    required String nom,
    required String prenom,
    String?         poste,
    int?            voix,
    @Default(false) bool elu,
  }) = _CandidatElection;

  String get nomComplet => '$prenom $nom';
}