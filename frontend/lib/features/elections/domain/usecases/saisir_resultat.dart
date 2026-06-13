import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/elections_repository.dart';

class SaisirResultat implements UseCase<void, ParamsSaisirResultat> {
  final ElectionsRepository repository;
  SaisirResultat(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsSaisirResultat params) =>
      repository.saisirResultat(params);
}