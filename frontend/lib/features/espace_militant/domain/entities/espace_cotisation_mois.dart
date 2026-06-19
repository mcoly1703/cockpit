import 'package:freezed_annotation/freezed_annotation.dart';

part 'espace_cotisation_mois.freezed.dart';

@freezed
class EspaceCotisationMois with _$EspaceCotisationMois {
  const factory EspaceCotisationMois({
    required int mois,
    required int annee,
    required double montantPaye,
    double? montantDu,
    required String statut,
  }) = _EspaceCotisationMois;
}
