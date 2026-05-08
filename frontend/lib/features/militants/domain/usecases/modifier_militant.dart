import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/militant.dart';
import '../repositories/militants_repository.dart';

class ModifierMilitant implements UseCase<Militant, ParamsModifierMilitant> {
  final MilitantsRepository repository;
  ModifierMilitant(this.repository);

  @override
  Future<Either<Failure, Militant>> call(ParamsModifierMilitant params) =>
      repository.modifierMilitant(params);
}