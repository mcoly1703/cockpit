import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prospect.dart';
import '../repositories/prospects_repository.dart';

class ParamsGetProspects {
  final String? uniteId;
  const ParamsGetProspects({this.uniteId});
}

class GetProspects implements UseCase<List<Prospect>, ParamsGetProspects> {
  final ProspectsRepository repository;
  GetProspects(this.repository);

  @override
  Future<Either<Failure, List<Prospect>>> call(ParamsGetProspects params) =>
      repository.getProspects(uniteId: params.uniteId);
}