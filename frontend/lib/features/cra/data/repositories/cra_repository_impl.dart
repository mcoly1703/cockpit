import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';
import '../datasources/cra_datasource.dart';

class CraRepositoryImpl implements CraRepository {
  final CraDatasource _datasource;
  CraRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<CompteRendu>>> getMesRendus(String uniteId) async {
    try {
      return Right(await _datasource.getMesRendus(uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<CompteRendu>>> getRendusRecus() async {
    try {
      return Right(await _datasource.getRendusRecus());
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> creerCr(ParamsCreerCr params) async {
    try {
      await _datasource.creerCr(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> mettreAJour(ParamsMajCr params) async {
    try {
      await _datasource.mettreAJour(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> soumettre(String crId) async {
    try {
      await _datasource.soumettre(crId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> valider(String crId) async {
    try {
      await _datasource.valider(crId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> retourner(String crId, String observations) async {
    try {
      await _datasource.retourner(crId, observations);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> supprimer(String crId) async {
    try {
      await _datasource.supprimer(crId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }
}