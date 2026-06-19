import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cotisation.dart';
import '../entities/donateur.dart';
import '../entities/transaction.dart';

abstract class FinancesRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions({String? uniteId});
  Future<Either<Failure, List<Cotisation>>>  getCotisations({String? uniteId, int? annee});
  Future<Either<Failure, Transaction>>       ajouterTransaction(ParamsAjouterTransaction params);
  Future<Either<Failure, Cotisation>>        enregistrerCotisation(ParamsEnregistrerCotisation params);
  Future<Either<Failure, List<Donateur>>>    getDonateurs();
  Future<Either<Failure, Donateur>>          creerDonateur(ParamsCreerDonateur params);
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

  final String?  donateurId;

  const ParamsAjouterTransaction({
    required this.type,
    required this.categorie,
    required this.montant,
    required this.dateTransaction,
    required this.uniteId,
    this.description,
    this.beneficiaire,
    this.militantId,
    this.donateurId,
  });
}

class ParamsCreerDonateur {
  final String nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String? ville;

  const ParamsCreerDonateur({
    required this.nom,
    this.prenom,
    this.telephone,
    this.email,
    this.ville,
  });
}

class ParamsEnregistrerCotisation {
  final String    militantId;
  final int       annee;
  final int?      mois;
  final double    montantPaye;
  final double?   montantDu;
  final String    statut;
  final String?   uniteId;
  final String?   modePaiement;
  final DateTime? datePaiement;

  const ParamsEnregistrerCotisation({
    required this.militantId,
    required this.annee,
    this.mois,
    required this.montantPaye,
    this.montantDu,
    required this.statut,
    this.uniteId,
    this.modePaiement,
    this.datePaiement,
  });
}