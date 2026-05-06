import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/utilisateur.dart';
import '../repositories/auth_repository.dart';

class SeConnecter implements UseCase<Utilisateur, ParamsSeConnecter> {
  final AuthRepository repository;
  SeConnecter(this.repository);

  @override
  Future<Either<Failure, Utilisateur>> call(ParamsSeConnecter params) =>
      repository.seConnecter(
        email: params.email,
        motDePasse: params.motDePasse,
      );
}

class ParamsSeConnecter {
  final String email;
  final String motDePasse;
  const ParamsSeConnecter({required this.email, required this.motDePasse});
}
