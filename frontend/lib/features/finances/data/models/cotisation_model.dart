import '../../domain/entities/cotisation.dart';

class CotisationModel {
  final String    id;
  final String    militantId;
  final int       annee;
  final double    montant;
  final String    statut;
  final String    createdBy;
  final DateTime? datePaiement;
  final String?   transactionId;

  const CotisationModel({
    required this.id,
    required this.militantId,
    required this.annee,
    required this.montant,
    required this.statut,
    required this.createdBy,
    this.datePaiement,
    this.transactionId,
  });

  factory CotisationModel.fromJson(Map<String, dynamic> j) => CotisationModel(
        id:            j['id'] as String,
        militantId:    j['militant_id'] as String,
        annee:         j['annee'] as int,
        montant:       (j['montant'] as num).toDouble(),
        statut:        j['statut'] as String,
        createdBy:     j['created_by'] as String,
        datePaiement:  j['date_paiement'] != null
            ? DateTime.parse(j['date_paiement'] as String)
            : null,
        transactionId: j['transaction_id'] as String?,
      );

  Cotisation toEntity() => Cotisation(
        id:            id,
        militantId:    militantId,
        annee:         annee,
        montant:       montant,
        statut:        statut,
        createdBy:     createdBy,
        datePaiement:  datePaiement,
        transactionId: transactionId,
      );
}