import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/unite_organisationnelle.dart';
import '../repositories/militants_repository.dart';

export '../repositories/militants_repository.dart' show ParamsCreerCellule;

class CreerCellule implements UseCase<UniteOrganisationnelle, ParamsCreerCellule> {
  final MilitantsRepository repository;
  CreerCellule(this.repository);

  @override
  Future<Either<Failure, UniteOrganisationnelle>> call(ParamsCreerCellule params) =>
      repository.creerCellule(params);
}