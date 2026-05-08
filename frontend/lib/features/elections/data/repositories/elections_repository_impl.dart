import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/candidat_election.dart';
import '../../domain/entities/scrutin.dart';
import '../../domain/repositories/elections_repository.dart';
import '../datasources/elections_datasource.dart';

class ElectionsRepositoryImpl implements ElectionsRepository {
  final ElectionsDatasource _datasource;
  ElectionsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Scrutin>>> getScrutins({String? uniteId}) async {
    try {
      return Right(await _datasource.getScrutins(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<CandidatElection>>> getCandidats(String scrutinId) async {
    try {
      return Right(await _datasource.getCandidats(scrutinId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> ajouterScrutin(ParamsAjouterScrutin params) async {
    try {
      await _datasource.ajouterScrutin(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> changerStatut(String scrutinId, String statut) async {
    try {
      await _datasource.changerStatut(scrutinId, statut);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> ajouterCandidat(ParamsAjouterCandidat params) async {
    try {
      await _datasource.ajouterCandidat(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> saisirResultat(ParamsSaisirResultat params) async {
    try {
      await _datasource.saisirResultat(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> retirerCandidat(String candidatId) async {
    try {
      await _datasource.retirerCandidat(candidatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }
}