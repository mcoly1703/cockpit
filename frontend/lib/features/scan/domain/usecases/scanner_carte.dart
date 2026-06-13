import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/resultat_scan.dart';
import '../repositories/scan_repository.dart';

class ScannerCarte implements UseCase<ResultatScan, String> {
  final ScanRepository repository;
  ScannerCarte(this.repository);

  @override
  Future<Either<Failure, ResultatScan>> call(String militantId) =>
      repository.scannerCarte(militantId);
}