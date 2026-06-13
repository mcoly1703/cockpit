import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/elections_repository.dart';

class RetirerCandidat implements UseCase<void, String> {
  final ElectionsRepository repository;
  RetirerCandidat(this.repository);

  @override
  Future<Either<Failure, void>> call(String candidatId) =>
      repository.retirerCandidat(candidatId);
}