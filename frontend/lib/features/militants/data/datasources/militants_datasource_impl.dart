import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/militants_repository.dart';
import '../models/militant_model.dart';
import '../models/unite_organisationnelle_model.dart';
import 'militants_datasource.dart';

class MilitantsDatasourceImpl implements MilitantsDatasource {
  final SupabaseClient supabase;
  MilitantsDatasourceImpl(this.supabase);

  @override
  Future<List<Militant>> getMilitants({
    String? uniteId,
    String? filtreStatut,
  }) async {
    try {
      var query = supabase.from(AppTables.militants).select('*');
      if (uniteId != null) query = query.eq(AppTables.colUniteId, uniteId);
      if (filtreStatut != null) query = query.eq(AppTables.colStatut, filtreStatut);
      final data = await query.order(AppTables.colNom);
      return (data as List).map((e) => MilitantModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<UniteOrganisationnelle>> getUnites() async {
    try {
      final data = await supabase
          .from(AppTables.unitesOrganisationnelles)
          .select('id, type, nom, code, parent_id, is_active')
          .eq(AppTables.colIsActive, true)
          .order(AppTables.colNom);
      return (data as List)
          .map((e) => UniteOrganisationnelleModel.fromJson(e).toEntity())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<Militant> ajouterMilitant(ParamsAjouterMilitant params) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from(AppTables.militants).insert({
        AppTables.colNom:          params.nom.toUpperCase(),
        AppTables.colPrenom:       params.prenom,
        AppTables.colTelephone:    params.telephone,
        AppTables.colEmail:        params.email,
        AppTables.colDateNaissance: params.dateNaissance
            ?.toIso8601String()
            .substring(0, 10),
        AppTables.colSexe:         params.sexe,
        AppTables.colVille:        params.ville,
        AppTables.colCodePostal:   params.codePostal,
        AppTables.colUniteId:      params.uniteId,
        AppTables.colStatut:       AppEnums.militantActif,
        AppTables.colDateAdhesion: params.dateAdhesion
            .toIso8601String()
            .substring(0, 10),
        AppTables.colCreatedBy:    userId,
      }).select().single();
      return MilitantModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<Militant> modifierMilitant(ParamsModifierMilitant params) async {
    try {
      final data = await supabase.from(AppTables.militants).update({
        AppTables.colNom:          params.nom.toUpperCase(),
        AppTables.colPrenom:       params.prenom,
        AppTables.colTelephone:    params.telephone,
        AppTables.colEmail:        params.email,
        AppTables.colDateNaissance: params.dateNaissance
            ?.toIso8601String()
            .substring(0, 10),
        AppTables.colSexe:         params.sexe,
        AppTables.colVille:        params.ville,
        AppTables.colCodePostal:   params.codePostal,
        AppTables.colUniteId:      params.uniteId,
        AppTables.colDateAdhesion: params.dateAdhesion
            .toIso8601String()
            .substring(0, 10),
      }).eq(AppTables.colId, params.id).select().single();
      return MilitantModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> toggleStatut(String id, String nouveauStatut) async {
    try {
      await supabase
          .from(AppTables.militants)
          .update({AppTables.colStatut: nouveauStatut})
          .eq(AppTables.colId, id);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<int> importerMilitants(List<Map<String, dynamic>> rows) async {
    try {
      final userId  = supabase.auth.currentUser!.id;
      final payload = rows
          .map((r) => {...r, AppTables.colCreatedBy: userId})
          .toList();
      await supabase.from(AppTables.militants).insert(payload);
      return payload.length;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }
}