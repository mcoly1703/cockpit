import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/reunion.dart';
import '../../domain/repositories/reunions_repository.dart';
import '../datasources/reunions_datasource.dart';

export '../../domain/repositories/reunions_repository.dart'
    show ParamsMettreAJourCR, ParamsUploaderFichierCR;

class ReunionsRepositoryImpl implements ReunionsRepository {
  final ReunionsDatasource datasource;
  ReunionsRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Reunion>>> getReunions({String? uniteId}) async {
    try {
      return Right(await datasource.getReunions(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Reunion>> ajouterReunion(ParamsAjouterReunion params) async {
    try {
      return Right(await datasource.ajouterReunion(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<Decision>>> getDecisions(String reunionId) async {
    try {
      return Right(await datasource.getDecisions(reunionId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Decision>> ajouterDecision(ParamsAjouterDecision params) async {
    try {
      return Right(await datasource.ajouterDecision(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Decision>> modifierStatutDecision({
    required String id,
    required String statut,
  }) async {
    try {
      return Right(await datasource.modifierStatutDecision(id: id, statut: statut));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Reunion>> mettreAJourCR(ParamsMettreAJourCR params) async {
    try {
      return Right(await datasource.mettreAJourCR(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, String>> uploaderFichierCR(ParamsUploaderFichierCR params) async {
    try {
      return Right(await datasource.uploaderFichierCR(
          params.reunionId, params.bytes, params.extension));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}