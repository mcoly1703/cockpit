import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/militants_repository.dart';

abstract class MilitantsDatasource {
  Future<List<Militant>> getMilitants({String? uniteId, String? filtreStatut});
  Future<List<UniteOrganisationnelle>> getUnites();
  Future<Militant> ajouterMilitant(ParamsAjouterMilitant params);
  Future<Militant> modifierMilitant(ParamsModifierMilitant params);
  Future<void> toggleStatut(String id, String nouveauStatut);
  Future<int> importerMilitants(List<Map<String, dynamic>> rows);
}