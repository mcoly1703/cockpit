import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reunion.dart';
import '../repositories/reunions_repository.dart';

class ParamsGetReunions {
  final String? uniteId;
  const ParamsGetReunions({this.uniteId});
}

class GetReunions implements UseCase<List<Reunion>, ParamsGetReunions> {
  final ReunionsRepository repository;
  GetReunions(this.repository);

  @override
  Future<Either<Failure, List<Reunion>>> call(ParamsGetReunions params) =>
      repository.getReunions(uniteId: params.uniteId);
}