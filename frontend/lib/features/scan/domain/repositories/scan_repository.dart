import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/resultat_scan.dart';

class ParamsEnregistrerPresenceScan {
  final String evenementId;
  final String militantId;
  final String nom;
  final String prenom;

  ParamsEnregistrerPresenceScan({
    required this.evenementId,
    required this.militantId,
    required this.nom,
    required this.prenom,
  });
}

abstract class ScanRepository {
  Future<Either<Failure, ResultatScan>> scannerCarte(String militantId);
  Future<Either<Failure, void>> enregistrerPresence(ParamsEnregistrerPresenceScan params);
}