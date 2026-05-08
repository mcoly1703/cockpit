import '../../domain/entities/poste_bureau.dart';
import '../../domain/repositories/bureau_repository.dart';

abstract class BureauDatasource {
  Future<List<PosteBureau>>    getPostesBureau(String uniteId);
  Future<PosteBureau>          nommerMembre(ParamsNommerMembre params);
  Future<void>                 retirerMembre(String id);
  Future<List<MilitantResume>> searchMilitants(String query, String uniteId);
}