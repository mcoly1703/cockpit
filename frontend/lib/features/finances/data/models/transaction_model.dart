import '../../domain/entities/transaction.dart';

class TransactionModel {
  final String   id;
  final String   type;
  final String   categorie;
  final double   montant;
  final DateTime dateTransaction;
  final String   uniteId;
  final String   createdBy;
  final String?  description;
  final String?  beneficiaire;
  final String?  pieceJustificativeUrl;
  final String?  militantId;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.categorie,
    required this.montant,
    required this.dateTransaction,
    required this.uniteId,
    required this.createdBy,
    this.description,
    this.beneficiaire,
    this.pieceJustificativeUrl,
    this.militantId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> j) => TransactionModel(
        id:                   j['id'] as String,
        type:                 j['type'] as String,
        categorie:            j['categorie'] as String,
        montant:              (j['montant'] as num).toDouble(),
        dateTransaction:      DateTime.parse(j['date_transaction'] as String),
        uniteId:              j['unite_id'] as String,
        createdBy:            j['created_by'] as String,
        description:          j['description'] as String?,
        beneficiaire:         j['beneficiaire'] as String?,
        pieceJustificativeUrl: j['piece_justificative_url'] as String?,
        militantId:           j['militant_id'] as String?,
      );

  Transaction toEntity() => Transaction(
        id:                   id,
        type:                 type,
        categorie:            categorie,
        montant:              montant,
        dateTransaction:      dateTransaction,
        uniteId:              uniteId,
        createdBy:            createdBy,
        description:          description,
        beneficiaire:         beneficiaire,
        pieceJustificativeUrl: pieceJustificativeUrl,
        militantId:           militantId,
      );
}