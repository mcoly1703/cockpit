import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/candidat_election.dart';
import '../repositories/elections_repository.dart';

class GetCandidats implements UseCase<List<CandidatElection>, String> {
  final ElectionsRepository repository;
  GetCandidats(this.repository);

  @override
  Future<Either<Failure, List<CandidatElection>>> call(String scrutinId) =>
      repository.getCandidats(scrutinId);
}