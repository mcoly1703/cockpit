import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/elections_repository.dart';

class AjouterCandidat implements UseCase<void, ParamsAjouterCandidat> {
  final ElectionsRepository repository;
  AjouterCandidat(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsAjouterCandidat params) =>
      repository.ajouterCandidat(params);
}