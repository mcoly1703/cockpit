import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/resultat_scan.dart';
import '../../domain/repositories/scan_repository.dart';
import '../datasources/scan_datasource.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanDatasource _datasource;
  ScanRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, ResultatScan>> scannerCarte(String militantId) async {
    try {
      return Right(await _datasource.scannerCarte(militantId));
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }

  @override
  Future<Either<Failure, void>> enregistrerPresence(
      ParamsEnregistrerPresenceScan params) async {
    try {
      await _datasource.enregistrerPresence(
        evenementId: params.evenementId,
        militantId:  params.militantId,
        nom:         params.nom,
        prenom:      params.prenom,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } catch (_) {
      return const Left(Failure.reseau());
    }
  }
}