import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/militants_repository.dart';
import '../datasources/militants_datasource.dart';

class MilitantsRepositoryImpl implements MilitantsRepository {
  final MilitantsDatasource _datasource;
  MilitantsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Militant>>> getMilitants({
    String? uniteId,
    String? filtreStatut,
  }) async {
    try {
      final result = await _datasource.getMilitants(
        uniteId: uniteId,
        filtreStatut: filtreStatut,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<UniteOrganisationnelle>>> getUnites() async {
    try {
      return Right(await _datasource.getUnites());
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Militant>> ajouterMilitant(
      ParamsAjouterMilitant params) async {
    try {
      return Right(await _datasource.ajouterMilitant(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Militant>> modifierMilitant(
      ParamsModifierMilitant params) async {
    try {
      return Right(await _datasource.modifierMilitant(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> toggleStatut(
      String id, String nouveauStatut) async {
    try {
      await _datasource.toggleStatut(id, nouveauStatut);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, int>> importerMilitants(
      List<Map<String, dynamic>> rows) async {
    try {
      return Right(await _datasource.importerMilitants(rows));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}