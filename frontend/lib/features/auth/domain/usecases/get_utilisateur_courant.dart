import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/utilisateur.dart';
import '../repositories/auth_repository.dart';

class GetUtilisateurCourant implements UseCase<Utilisateur?, NoParams> {
  final AuthRepository repository;
  GetUtilisateurCourant(this.repository);

  @override
  Future<Either<Failure, Utilisateur?>> call(NoParams params) =>
      repository.getUtilisateurCourant();
}
