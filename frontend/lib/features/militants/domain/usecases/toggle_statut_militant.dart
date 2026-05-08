import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/militants_repository.dart';

class ParamsToggleStatut {
  final String id;
  final String nouveauStatut;
  const ParamsToggleStatut({required this.id, required this.nouveauStatut});
}

class ToggleStatutMilitant implements UseCase<void, ParamsToggleStatut> {
  final MilitantsRepository repository;
  ToggleStatutMilitant(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsToggleStatut params) =>
      repository.toggleStatut(params.id, params.nouveauStatut);
}