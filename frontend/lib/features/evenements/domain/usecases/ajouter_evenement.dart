import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/evenement.dart';
import '../repositories/evenements_repository.dart';

export '../repositories/evenements_repository.dart' show ParamsAjouterEvenement;

class AjouterEvenement implements UseCase<Evenement, ParamsAjouterEvenement> {
  final EvenementsRepository repository;
  AjouterEvenement(this.repository);

  @override
  Future<Either<Failure, Evenement>> call(ParamsAjouterEvenement params) =>
      repository.ajouterEvenement(params);
}