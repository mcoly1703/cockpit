import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reunion.dart';
import '../repositories/reunions_repository.dart';

export '../repositories/reunions_repository.dart' show ParamsMettreAJourCR;

class MettreAJourCR implements UseCase<Reunion, ParamsMettreAJourCR> {
  final ReunionsRepository repository;
  MettreAJourCR(this.repository);

  @override
  Future<Either<Failure, Reunion>> call(ParamsMettreAJourCR params) =>
      repository.mettreAJourCR(params);
}