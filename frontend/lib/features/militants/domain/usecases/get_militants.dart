import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/militant.dart';
import '../repositories/militants_repository.dart';

class ParamsGetMilitants {
  final String? uniteId;
  final String? filtreStatut;

  const ParamsGetMilitants({this.uniteId, this.filtreStatut});
}

class GetMilitants implements UseCase<List<Militant>, ParamsGetMilitants> {
  final MilitantsRepository repository;
  GetMilitants(this.repository);

  @override
  Future<Either<Failure, List<Militant>>> call(ParamsGetMilitants params) =>
      repository.getMilitants(
        uniteId: params.uniteId,
        filtreStatut: params.filtreStatut,
      );
}