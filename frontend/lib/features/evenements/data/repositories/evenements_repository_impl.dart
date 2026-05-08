import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/evenement.dart';
import '../../domain/entities/presence.dart';
import '../../domain/repositories/evenements_repository.dart';
import '../datasources/evenements_datasource.dart';

class EvenementsRepositoryImpl implements EvenementsRepository {
  final EvenementsDatasource datasource;
  EvenementsRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Evenement>>> getEvenements({String? uniteId}) async {
    try {
      return Right(await datasource.getEvenements(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Evenement>> ajouterEvenement(ParamsAjouterEvenement params) async {
    try {
      return Right(await datasource.ajouterEvenement(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<Presence>>> getPresences(String evenementId) async {
    try {
      return Right(await datasource.getPresences(evenementId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Presence>> enregistrerPresence(ParamsEnregistrerPresence params) async {
    try {
      return Right(await datasource.enregistrerPresence(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}