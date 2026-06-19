import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/espace_finances_resume.dart';
import '../repositories/espace_militant_repository.dart';

class ParamsEspaceFinances {
  final String uniteId;
  const ParamsEspaceFinances({required this.uniteId});
}

class GetEspaceFinances
    implements UseCase<EspaceFinancesResume, ParamsEspaceFinances> {
  final EspaceMilitantRepository repository;
  GetEspaceFinances(this.repository);

  @override
  Future<Either<Failure, EspaceFinancesResume>> call(
          ParamsEspaceFinances params) =>
      repository.getFinances(uniteId: params.uniteId);
}
