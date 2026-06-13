import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cra_repository.dart';

class CreerCr implements UseCase<void, ParamsCreerCr> {
  final CraRepository repository;
  CreerCr(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsCreerCr params) =>
      repository.creerCr(params);
}