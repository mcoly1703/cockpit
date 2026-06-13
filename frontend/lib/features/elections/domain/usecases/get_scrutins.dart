import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scrutin.dart';
import '../repositories/elections_repository.dart';

class ParamsGetScrutins {
  final String? uniteId;
  const ParamsGetScrutins({this.uniteId});
}

class GetScrutins implements UseCase<List<Scrutin>, ParamsGetScrutins> {
  final ElectionsRepository repository;
  GetScrutins(this.repository);

  @override
  Future<Either<Failure, List<Scrutin>>> call(ParamsGetScrutins params) =>
      repository.getScrutins(uniteId: params.uniteId);
}