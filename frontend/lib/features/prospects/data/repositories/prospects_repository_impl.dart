import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/prospect.dart';
import '../../domain/repositories/prospects_repository.dart';
import '../datasources/prospects_datasource.dart';

class ProspectsRepositoryImpl implements ProspectsRepository {
  final ProspectsDatasource datasource;
  ProspectsRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Prospect>>> getProspects({String? uniteId}) async {
    try {
      return Right(await datasource.getProspects(uniteId: uniteId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Prospect>> ajouterProspect(ParamsAjouterProspect params) async {
    try {
      return Right(await datasource.ajouterProspect(params));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, Prospect>> modifierEtapeProspect({
    required String id,
    required String etape,
  }) async {
    try {
      return Right(await datasource.modifierEtapeProspect(id: id, etape: etape));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}