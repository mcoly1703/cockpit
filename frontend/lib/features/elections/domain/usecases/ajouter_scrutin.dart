import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/elections_repository.dart';

class AjouterScrutin implements UseCase<void, ParamsAjouterScrutin> {
  final ElectionsRepository repository;
  AjouterScrutin(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsAjouterScrutin params) =>
      repository.ajouterScrutin(params);
}