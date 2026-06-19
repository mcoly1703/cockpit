import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/espace_militant_info.dart';
import '../repositories/espace_militant_repository.dart';

class ParamsVerifierMilitant {
  final String numeroCarte;
  final String telephone;
  const ParamsVerifierMilitant({
    required this.numeroCarte,
    required this.telephone,
  });
}

class VerifierMilitant
    implements UseCase<EspaceMilitantInfo, ParamsVerifierMilitant> {
  final EspaceMilitantRepository repository;
  VerifierMilitant(this.repository);

  @override
  Future<Either<Failure, EspaceMilitantInfo>> call(
          ParamsVerifierMilitant params) =>
      repository.verifierMilitant(
        numeroCarte: params.numeroCarte,
        telephone: params.telephone,
      );
}
