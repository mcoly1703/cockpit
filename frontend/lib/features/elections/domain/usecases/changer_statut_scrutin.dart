import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/elections_repository.dart';

class ParamsChangerStatut {
  final String scrutinId;
  final String statut;
  ParamsChangerStatut({required this.scrutinId, required this.statut});
}

class ChangerStatutScrutin implements UseCase<void, ParamsChangerStatut> {
  final ElectionsRepository repository;
  ChangerStatutScrutin(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsChangerStatut params) =>
      repository.changerStatut(params.scrutinId, params.statut);
}