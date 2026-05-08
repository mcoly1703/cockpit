import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/presence.dart';
import '../repositories/evenements_repository.dart';

class GetPresences implements UseCase<List<Presence>, String> {
  final EvenementsRepository repository;
  GetPresences(this.repository);

  @override
  Future<Either<Failure, List<Presence>>> call(String evenementId) =>
      repository.getPresences(evenementId);
}