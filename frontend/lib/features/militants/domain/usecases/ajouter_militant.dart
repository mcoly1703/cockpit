import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/militant.dart';
import '../repositories/militants_repository.dart';

class AjouterMilitant implements UseCase<Militant, ParamsAjouterMilitant> {
  final MilitantsRepository repository;
  AjouterMilitant(this.repository);

  @override
  Future<Either<Failure, Militant>> call(ParamsAjouterMilitant params) =>
      repository.ajouterMilitant(params);
}