import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cotisation.dart';
import '../../domain/entities/donateur.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finances_repository.dart';
import '../datasources/finances_datasource.dart';

class FinancesRepositoryImpl implements FinancesRepository {
  final FinancesDatasource datasource;
  FinancesRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({String? uniteId}) async {
    try {
      return Right(await datasource.getTransactions(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<Cotisation>>> getCotisations({String? uniteId, int? annee}) async {
    try {
      return Right(await datasource.getCotisations(uniteId: uniteId, annee: annee));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Transaction>> ajouterTransaction(ParamsAjouterTransaction params) async {
    try {
      return Right(await datasource.ajouterTransaction(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Cotisation>> enregistrerCotisation(ParamsEnregistrerCotisation params) async {
    try {
      return Right(await datasource.enregistrerCotisation(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<Donateur>>> getDonateurs() async {
    try {
      return Right(await datasource.getDonateurs());
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Donateur>> creerDonateur(ParamsCreerDonateur params) async {
    try {
      return Right(await datasource.creerDonateur(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}