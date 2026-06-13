import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cra_repository.dart';

class SupprimerCr implements UseCase<void, String> {
  final CraRepository repository;
  SupprimerCr(this.repository);

  @override
  Future<Either<Failure, void>> call(String crId) =>
      repository.supprimer(crId);
}