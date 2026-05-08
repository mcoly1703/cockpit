import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cotisation.dart';
import '../repositories/finances_repository.dart';

class EnregistrerCotisation {
  final FinancesRepository repository;
  EnregistrerCotisation(this.repository);

  Future<Either<Failure, Cotisation>> call(ParamsEnregistrerCotisation params) =>
      repository.enregistrerCotisation(params);
}