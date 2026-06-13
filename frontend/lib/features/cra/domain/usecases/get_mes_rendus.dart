import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/compte_rendu.dart';
import '../repositories/cra_repository.dart';

class GetMesRendus implements UseCase<List<CompteRendu>, String> {
  final CraRepository repository;
  GetMesRendus(this.repository);

  @override
  Future<Either<Failure, List<CompteRendu>>> call(String uniteId) =>
      repository.getMesRendus(uniteId);
}