import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String   id,
    required String   type,
    required String   categorie,
    required double   montant,
    required DateTime dateTransaction,
    required String   uniteId,
    required String   createdBy,
    String?           description,
    String?           beneficiaire,
    String?           pieceJustificativeUrl,
    String?           militantId,
  }) = _Transaction;
}