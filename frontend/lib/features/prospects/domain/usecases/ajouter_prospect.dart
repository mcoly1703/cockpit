import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prospect.dart';
import '../repositories/prospects_repository.dart';

export '../repositories/prospects_repository.dart' show ParamsAjouterProspect;

class AjouterProspect implements UseCase<Prospect, ParamsAjouterProspect> {
  final ProspectsRepository repository;
  AjouterProspect(this.repository);

  @override
  Future<Either<Failure, Prospect>> call(ParamsAjouterProspect params) =>
      repository.ajouterProspect(params);
}