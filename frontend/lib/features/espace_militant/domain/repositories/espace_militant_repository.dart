import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/espace_cotisation_mois.dart';
import '../entities/espace_finances_resume.dart';
import '../entities/espace_militant_info.dart';

abstract class EspaceMilitantRepository {
  Future<Either<Failure, EspaceMilitantInfo>> verifierMilitant({
    required String numeroCarte,
    required String telephone,
  });

  Future<Either<Failure, List<EspaceCotisationMois>>> getCotisations({
    required String militantId,
  });

  Future<Either<Failure, EspaceFinancesResume>> getFinances({
    required String uniteId,
  });
}
