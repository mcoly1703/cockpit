import '../../domain/entities/espace_cotisation_mois.dart';
import '../../domain/entities/espace_finances_resume.dart';
import '../../domain/entities/espace_militant_info.dart';

abstract class EspaceMilitantDatasource {
  Future<EspaceMilitantInfo> verifierMilitant({
    required String numeroCarte,
    required String telephone,
  });

  Future<List<EspaceCotisationMois>> getCotisations({
    required String militantId,
  });

  Future<EspaceFinancesResume> getFinances({required String uniteId});
}
