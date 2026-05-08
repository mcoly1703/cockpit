import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/presence.dart';
import '../repositories/evenements_repository.dart';

export '../repositories/evenements_repository.dart' show ParamsEnregistrerPresence;

class EnregistrerPresence implements UseCase<Presence, ParamsEnregistrerPresence> {
  final EvenementsRepository repository;
  EnregistrerPresence(this.repository);

  @override
  Future<Either<Failure, Presence>> call(ParamsEnregistrerPresence params) =>
      repository.enregistrerPresence(params);
}