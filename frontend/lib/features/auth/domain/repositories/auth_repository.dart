import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

import '../../../../core/errors/failures.dart';
import '../entities/utilisateur.dart';

abstract class AuthRepository {
  Future<Either<Failure, Utilisateur>> seConnecter({
    required String email,
    required String motDePasse,
  });

  Future<Either<Failure, void>> seDeconnecter();

  Future<Either<Failure, Utilisateur?>> getUtilisateurCourant();
}
