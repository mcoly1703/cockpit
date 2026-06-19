import 'package:freezed_annotation/freezed_annotation.dart';

part 'espace_finances_resume.freezed.dart';

@freezed
class EspaceFinancesResume with _$EspaceFinancesResume {
  const factory EspaceFinancesResume({
    required double celluleSolde,
    required int celluleNbMembres,
    String? sousSectionId,
    String? sousSectionNom,
    double? sousSectionSolde,
    int? sousSectionNbMembres,
  }) = _EspaceFinancesResume;
}
