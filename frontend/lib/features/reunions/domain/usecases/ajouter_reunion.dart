import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reunion.dart';
import '../repositories/reunions_repository.dart';

export '../repositories/reunions_repository.dart' show ParamsAjouterReunion;

class AjouterReunion implements UseCase<Reunion, ParamsAjouterReunion> {
  final ReunionsRepository repository;
  AjouterReunion(this.repository);

  @override
  Future<Either<Failure, Reunion>> call(ParamsAjouterReunion params) =>
      repository.ajouterReunion(params);
}