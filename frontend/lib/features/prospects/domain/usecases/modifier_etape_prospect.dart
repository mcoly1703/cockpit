import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prospect.dart';
import '../repositories/prospects_repository.dart';

class ParamsModifierEtape {
  final String id;
  final String etape;
  const ParamsModifierEtape({required this.id, required this.etape});
}

class ModifierEtapeProspect implements UseCase<Prospect, ParamsModifierEtape> {
  final ProspectsRepository repository;
  ModifierEtapeProspect(this.repository);

  @override
  Future<Either<Failure, Prospect>> call(ParamsModifierEtape params) =>
      repository.modifierEtapeProspect(id: params.id, etape: params.etape);
}