import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/espace_cotisation_mois.dart';
import '../../domain/entities/espace_finances_resume.dart';
import '../../domain/entities/espace_militant_info.dart';
import '../../domain/repositories/espace_militant_repository.dart';
import '../datasources/espace_militant_datasource.dart';

class EspaceMilitantRepositoryImpl implements EspaceMilitantRepository {
  final EspaceMilitantDatasource datasource;
  EspaceMilitantRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, EspaceMilitantInfo>> verifierMilitant({
    required String numeroCarte,
    required String telephone,
  }) async {
    try {
      final result = await datasource.verifierMilitant(
        numeroCarte: numeroCarte,
        telephone: telephone,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<EspaceCotisationMois>>> getCotisations({
    required String militantId,
  }) async {
    try {
      return Right(await datasource.getCotisations(militantId: militantId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, EspaceFinancesResume>> getFinances({
    required String uniteId,
  }) async {
    try {
      return Right(await datasource.getFinances(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}
