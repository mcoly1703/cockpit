import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/scan_repository.dart';

class EnregistrerPresenceScan
    implements UseCase<void, ParamsEnregistrerPresenceScan> {
  final ScanRepository repository;
  EnregistrerPresenceScan(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsEnregistrerPresenceScan params) =>
      repository.enregistrerPresence(params);
}