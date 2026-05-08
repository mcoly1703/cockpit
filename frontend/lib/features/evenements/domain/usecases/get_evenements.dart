import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/evenement.dart';
import '../repositories/evenements_repository.dart';

class ParamsGetEvenements {
  final String? uniteId;
  const ParamsGetEvenements({this.uniteId});
}

class GetEvenements implements UseCase<List<Evenement>, ParamsGetEvenements> {
  final EvenementsRepository repository;
  GetEvenements(this.repository);

  @override
  Future<Either<Failure, List<Evenement>>> call(ParamsGetEvenements params) =>
      repository.getEvenements(uniteId: params.uniteId);
}