import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cotisation.dart';
import '../repositories/finances_repository.dart';

class ParamsGetCotisations {
  final String? uniteId;
  final int?    annee;
  const ParamsGetCotisations({this.uniteId, this.annee});
}

class GetCotisations {
  final FinancesRepository repository;
  GetCotisations(this.repository);

  Future<Either<Failure, List<Cotisation>>> call(ParamsGetCotisations params) =>
      repository.getCotisations(uniteId: params.uniteId, annee: params.annee);
}