import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cra_repository.dart';

class ParamsRetournerCr {
  final String crId;
  final String observations;
  ParamsRetournerCr({required this.crId, required this.observations});
}

class RetournerCr implements UseCase<void, ParamsRetournerCr> {
  final CraRepository repository;
  RetournerCr(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsRetournerCr params) =>
      repository.retourner(params.crId, params.observations);
}