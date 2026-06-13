import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cra_repository.dart';

class MettreAJourCr implements UseCase<void, ParamsMajCr> {
  final CraRepository repository;
  MettreAJourCr(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsMajCr params) =>
      repository.mettreAJour(params);
}