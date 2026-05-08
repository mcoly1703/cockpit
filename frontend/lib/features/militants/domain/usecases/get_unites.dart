import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/unite_organisationnelle.dart';
import '../repositories/militants_repository.dart';

class GetUnites implements UseCase<List<UniteOrganisationnelle>, NoParams> {
  final MilitantsRepository repository;
  GetUnites(this.repository);

  @override
  Future<Either<Failure, List<UniteOrganisationnelle>>> call(NoParams params) =>
      repository.getUnites();
}