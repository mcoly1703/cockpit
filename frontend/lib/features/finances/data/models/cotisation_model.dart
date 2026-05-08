import '../../domain/entities/cotisation.dart';

class CotisationModel {
  final String    id;
  final String    militantId;
  final int       annee;
  final int?      mois;
  final double    montantPaye;
  final double?   montantDu;
  final String    statut;
  final String    createdBy;
  final String?   uniteId;
  final String?   modePaiement;
  final DateTime? datePaiement;
  final String?   transactionId;

  const CotisationModel({
    required this.id,
    required this.militantId,
    required this.annee,
    this.mois,
    required this.montantPaye,
    this.montantDu,
    required this.statut,
    required this.createdBy,
    this.uniteId,
    this.modePaiement,
    this.datePaiement,
    this.transactionId,
  });

  factory CotisationModel.fromJson(Map<String, dynamic> j) => CotisationModel(
        id:           j['id'] as String,
        militantId:   j['militant_id'] as String,
        annee:        j['annee'] as int,
        mois:         j['mois'] as int?,
        montantPaye:  (j['montant_paye'] as num).toDouble(),
        montantDu:    j['montant_du'] != null ? (j['montant_du'] as num).toDouble() : null,
        statut:       j['statut'] as String,
        createdBy:    j['created_by'] as String,
        uniteId:      j['unite_id'] as String?,
        modePaiement: j['mode_paiement'] as String?,
        datePaiement: j['date_paiement'] != null
            ? DateTime.parse(j['date_paiement'] as String)
            : null,
        transactionId: j['transaction_id'] as String?,
      );

  Cotisation toEntity() => Cotisation(
        id:            id,
        militantId:    militantId,
        annee:         annee,
        mois:          mois,
        montantPaye:   montantPaye,
        montantDu:     montantDu,
        statut:        statut,
        createdBy:     createdBy,
        uniteId:       uniteId,
        modePaiement:  modePaiement,
        datePaiement:  datePaiement,
        transactionId: transactionId,
      );
}
