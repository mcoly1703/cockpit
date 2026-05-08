import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cotisation.dart';
import '../entities/transaction.dart';

abstract class FinancesRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions({String? uniteId});
  Future<Either<Failure, List<Cotisation>>>  getCotisations({String? uniteId, int? annee});
  Future<Either<Failure, Transaction>>       ajouterTransaction(ParamsAjouterTransaction params);
  Future<Either<Failure, Cotisation>>        enregistrerCotisation(ParamsEnregistrerCotisation params);
}

class ParamsAjouterTransaction {
  final String   type;
  final String   categorie;
  final double   montant;
  final DateTime dateTransaction;
  final String   uniteId;
  final String?  description;
  final String?  beneficiaire;
  final String?  militantId;

  const ParamsAjouterTransaction({
    required this.type,
    required this.categorie,
    required this.montant,
    required this.dateTransaction,
    required this.uniteId,
    this.description,
    this.beneficiaire,
    this.militantId,
  });
}

class ParamsEnregistrerCotisation {
  final String   militantId;
  final int      annee;
  final double   montant;
  final String   statut;
  final DateTime? datePaiement;

  const ParamsEnregistrerCotisation({
    required this.militantId,
    required this.annee,
    required this.montant,
    required this.statut,
    this.datePaiement,
  });
}