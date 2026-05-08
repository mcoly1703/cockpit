import '../../domain/entities/evenement.dart';
import '../../domain/entities/presence.dart';
import '../../domain/repositories/evenements_repository.dart';

abstract class EvenementsDatasource {
  Future<List<Evenement>> getEvenements({String? uniteId});
  Future<Evenement>       ajouterEvenement(ParamsAjouterEvenement params);
  Future<List<Presence>>  getPresences(String evenementId);
  Future<Presence>        enregistrerPresence(ParamsEnregistrerPresence params);
}