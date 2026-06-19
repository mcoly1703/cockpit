import '../../domain/entities/cotisation.dart';
import '../../domain/entities/donateur.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finances_repository.dart';

abstract class FinancesDatasource {
  Future<List<Transaction>> getTransactions({String? uniteId});
  Future<List<Cotisation>>  getCotisations({String? uniteId, int? annee});
  Future<Transaction>       ajouterTransaction(ParamsAjouterTransaction params);
  Future<Cotisation>        enregistrerCotisation(ParamsEnregistrerCotisation params);
  Future<List<Donateur>>    getDonateurs();
  Future<Donateur>          creerDonateur(ParamsCreerDonateur params);
}