import '../../domain/entities/prospect.dart';
import '../../domain/repositories/prospects_repository.dart';

abstract class ProspectsDatasource {
  Future<List<Prospect>> getProspects({String? uniteId});
  Future<Prospect>       ajouterProspect(ParamsAjouterProspect params);
  Future<Prospect>       modifierEtapeProspect({required String id, required String etape});
}