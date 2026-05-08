import 'package:freezed_annotation/freezed_annotation.dart';

part 'cotisation.freezed.dart';

@freezed
class Cotisation with _$Cotisation {
  const factory Cotisation({
    required String  id,
    required String  militantId,
    required int     annee,
    int?             mois,          // 1-12 ; null = enregistrement annuel (legacy)
    required double  montantPaye,
    double?          montantDu,     // montant attendu pour ce mois (ex. 10 €)
    required String  statut,        // payee | partiel | en_retard | en_attente
    required String  createdBy,
    String?          uniteId,       // dénormalisé depuis militants.unite_id
    String?          modePaiement,  // espèces | virement | paypal | lydia...
    DateTime?        datePaiement,
    String?          transactionId,
  }) = _Cotisation;
}
