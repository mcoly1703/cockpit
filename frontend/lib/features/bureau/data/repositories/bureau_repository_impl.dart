import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/poste_bureau.dart';
import '../../domain/repositories/bureau_repository.dart';
import '../datasources/bureau_datasource.dart';

class BureauRepositoryImpl implements BureauRepository {
  final BureauDatasource datasource;
  BureauRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<PosteBureau>>> getPostesBureau(String uniteId) async {
    try {
      return Right(await datasource.getPostesBureau(uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, PosteBureau>> nommerMembre(ParamsNommerMembre params) async {
    try {
      return Right(await datasource.nommerMembre(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> retirerMembre(String id) async {
    try {
      await datasource.retirerMembre(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, List<MilitantResume>>> searchMilitants(
      String query, String uniteId) async {
    try {
      return Right(await datasource.searchMilitants(query, uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}