import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/poste_bureau.dart';
import '../../domain/repositories/bureau_repository.dart';
import '../models/poste_bureau_model.dart';
import 'bureau_datasource.dart';

class BureauDatasourceImpl implements BureauDatasource {
  final SupabaseClient supabase;
  BureauDatasourceImpl(this.supabase);

  @override
  Future<List<PosteBureau>> getPostesBureau(String uniteId) async {
    try {
      final data = await supabase
          .from(AppTables.postesBureau)
          .select('*, ${AppTables.militants}(${AppTables.colNom}, ${AppTables.colPrenom})')
          .eq(AppTables.colUniteId, uniteId)
          .order(AppTables.colDateNomination);
      return data.map((e) => PosteBureauModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Bureau] getPostesBureau: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<PosteBureau> nommerMembre(ParamsNommerMembre params) async {
    try {
      final result = await supabase
          .from(AppTables.postesBureau)
          .upsert(
            {
              AppTables.colUniteId:         params.uniteId,
              AppTables.colIntitule:         params.intitule,
              AppTables.colMilitantId:       params.militantId,
              AppTables.colDateNomination:   params.dateNomination.toIso8601String().substring(0, 10),
              AppTables.colCreatedBy:        supabase.auth.currentUser!.id,
            },
            onConflict: '${AppTables.colUniteId},${AppTables.colIntitule}',
          )
          .select('*, ${AppTables.militants}(${AppTables.colNom}, ${AppTables.colPrenom})')
          .single();
      return PosteBureauModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Bureau] nommerMembre: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<void> retirerMembre(String id) async {
    try {
      await supabase
          .from(AppTables.postesBureau)
          .delete()
          .eq(AppTables.colId, id);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Bureau] retirerMembre: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<List<MilitantResume>> searchMilitants(String query, String uniteId) async {
    try {
      final data = await supabase
          .from(AppTables.militants)
          .select('${AppTables.colId}, ${AppTables.colNom}, ${AppTables.colPrenom}')
          .eq(AppTables.colStatut, AppEnums.militantActif)
          .or('${AppTables.colNom}.ilike.%$query%,${AppTables.colPrenom}.ilike.%$query%')
          .order(AppTables.colNom)
          .limit(20);
      return data
          .map((e) => MilitantResume(
                id:     e[AppTables.colId] as String,
                nom:    e[AppTables.colNom] as String,
                prenom: e[AppTables.colPrenom] as String,
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Bureau] searchMilitants: $e\n$stack');
      throw const NetworkException();
    }
  }
}