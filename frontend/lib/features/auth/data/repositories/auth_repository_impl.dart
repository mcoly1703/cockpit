import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/utilisateur.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Utilisateur>> seConnecter({
    required String email,
    required String motDePasse,
  }) async {
    try {
      final utilisateur = await datasource.seConnecter(
        email: email,
        motDePasse: motDePasse,
      );
      return Right(utilisateur);
    } on UnauthorizedException {
      return const Left(Failure.nonAutorise());
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> seDeconnecter() async {
    try {
      await datasource.seDeconnecter();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Utilisateur?>> getUtilisateurCourant() async {
    try {
      final utilisateur = await datasource.getUtilisateurCourant();
      return Right(utilisateur);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}
