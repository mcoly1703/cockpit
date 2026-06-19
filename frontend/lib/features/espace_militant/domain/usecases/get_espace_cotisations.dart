import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/espace_cotisation_mois.dart';
import '../repositories/espace_militant_repository.dart';

class ParamsEspaceCotisations {
  final String militantId;
  const ParamsEspaceCotisations({required this.militantId});
}

class GetEspaceCotisations
    implements UseCase<List<EspaceCotisationMois>, ParamsEspaceCotisations> {
  final EspaceMilitantRepository repository;
  GetEspaceCotisations(this.repository);

  @override
  Future<Either<Failure, List<EspaceCotisationMois>>> call(
          ParamsEspaceCotisations params) =>
      repository.getCotisations(militantId: params.militantId);
}
