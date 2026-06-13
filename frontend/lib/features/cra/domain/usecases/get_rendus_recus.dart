import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/compte_rendu.dart';
import '../repositories/cra_repository.dart';

class GetRendusRecus implements UseCase<List<CompteRendu>, NoParams> {
  final CraRepository repository;
  GetRendusRecus(this.repository);

  @override
  Future<Either<Failure, List<CompteRendu>>> call(NoParams params) =>
      repository.getRendusRecus();
}