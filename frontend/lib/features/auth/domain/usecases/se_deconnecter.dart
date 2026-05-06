import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SeDeconnecter implements UseCase<void, NoParams> {
  final AuthRepository repository;
  SeDeconnecter(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.seDeconnecter();
}
