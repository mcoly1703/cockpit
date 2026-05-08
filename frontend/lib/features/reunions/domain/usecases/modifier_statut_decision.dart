import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/decision.dart';
import '../repositories/reunions_repository.dart';

class ParamsModifierStatutDecision {
  final String id;
  final String statut;
  const ParamsModifierStatutDecision({required this.id, required this.statut});
}

class ModifierStatutDecision implements UseCase<Decision, ParamsModifierStatutDecision> {
  final ReunionsRepository repository;
  ModifierStatutDecision(this.repository);

  @override
  Future<Either<Failure, Decision>> call(ParamsModifierStatutDecision params) =>
      repository.modifierStatutDecision(id: params.id, statut: params.statut);
}