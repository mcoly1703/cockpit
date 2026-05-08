import 'package:freezed_annotation/freezed_annotation.dart';

part 'cotisation.freezed.dart';

@freezed
class Cotisation with _$Cotisation {
  const factory Cotisation({
    required String  id,
    required String  militantId,
    required int     annee,
    required double  montant,
    required String  statut,
    required String  createdBy,
    DateTime?        datePaiement,
    String?          transactionId,
  }) = _Cotisation;
}