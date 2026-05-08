import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/decision.dart';
import '../repositories/reunions_repository.dart';

export '../repositories/reunions_repository.dart' show ParamsAjouterDecision;

class AjouterDecision implements UseCase<Decision, ParamsAjouterDecision> {
  final ReunionsRepository repository;
  AjouterDecision(this.repository);

  @override
  Future<Either<Failure, Decision>> call(ParamsAjouterDecision params) =>
      repository.ajouterDecision(params);
}