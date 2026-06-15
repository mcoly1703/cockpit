import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reunions_repository.dart';

export '../repositories/reunions_repository.dart' show ParamsUploaderFichierCR;

class UploaderFichierCR implements UseCase<String, ParamsUploaderFichierCR> {
  final ReunionsRepository repository;
  UploaderFichierCR(this.repository);

  @override
  Future<Either<Failure, String>> call(ParamsUploaderFichierCR params) =>
      repository.uploaderFichierCR(params);
}