import 'package:freezed_annotation/freezed_annotation.dart';

part 'resultat_scan.freezed.dart';

@freezed
class ResultatScan with _$ResultatScan {
  const factory ResultatScan.valide({
    required String  nom,
    required String  prenom,
    String?          numeroCarte,
    String?          statutCotis,
  }) = _Valide;

  const factory ResultatScan.retard({
    required String  nom,
    required String  prenom,
    String?          numeroCarte,
    required String  periodeRetard,
  }) = _Retard;

  const factory ResultatScan.suspendu({
    required String  nom,
    required String  prenom,
  }) = _Suspendu;

  const factory ResultatScan.inconnu() = _Inconnu;
}