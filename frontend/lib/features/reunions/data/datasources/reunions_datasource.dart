import '../../domain/entities/decision.dart';
import '../../domain/entities/reunion.dart';
import '../../domain/repositories/reunions_repository.dart';

abstract class ReunionsDatasource {
  Future<List<Reunion>>  getReunions({String? uniteId});
  Future<Reunion>        ajouterReunion(ParamsAjouterReunion params);
  Future<List<Decision>> getDecisions(String reunionId);
  Future<Decision>       ajouterDecision(ParamsAjouterDecision params);
  Future<Decision>       modifierStatutDecision({required String id, required String statut});
}