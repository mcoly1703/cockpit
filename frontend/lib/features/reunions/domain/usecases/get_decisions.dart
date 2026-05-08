import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/decision.dart';
import '../repositories/reunions_repository.dart';

class GetDecisions implements UseCase<List<Decision>, String> {
  final ReunionsRepository repository;
  GetDecisions(this.repository);

  @override
  Future<Either<Failure, List<Decision>>> call(String reunionId) =>
      repository.getDecisions(reunionId);
}