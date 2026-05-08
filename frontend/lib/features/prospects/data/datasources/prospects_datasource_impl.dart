import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/prospect.dart';
import '../../domain/repositories/prospects_repository.dart';
import '../models/prospect_model.dart';
import 'prospects_datasource.dart';

class ProspectsDatasourceImpl implements ProspectsDatasource {
  final SupabaseClient supabase;
  ProspectsDatasourceImpl(this.supabase);

  @override
  Future<List<Prospect>> getProspects({String? uniteId}) async {
    try {
      var query = supabase.from(AppTables.prospects).select();
      if (uniteId != null) query = query.eq(AppTables.colUniteId, uniteId);

      final data = await query.order(AppTables.colCreatedAt, ascending: false);
      return data.map((e) => ProspectModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Prospects] getProspects: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Prospect> ajouterProspect(ParamsAjouterProspect params) async {
    try {
      final result = await supabase
          .from(AppTables.prospects)
          .insert({
            AppTables.colNom:            params.nom,
            AppTables.colPrenom:         params.prenom,
            AppTables.colTelephone:      params.telephone,
            if (params.email != null)
              AppTables.colEmail:        params.email,
            AppTables.colVille:          params.ville,
            if (params.sexe != null)
              AppTables.colSexe:         params.sexe,
            if (params.mouvementInteret != null)
              AppTables.colMouvementInteret: params.mouvementInteret,
            if (params.notes != null)
              AppTables.colNotes:        params.notes,
            AppTables.colUniteId:        params.uniteId,
            AppTables.colEtape:          AppEnums.etapeContact,
            AppTables.colDateContact:    DateTime.now().toIso8601String().substring(0, 10),
            AppTables.colCreatedBy:      supabase.auth.currentUser!.id,
          })
          .select()
          .single();
      return ProspectModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Prospects] ajouterProspect: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Prospect> modifierEtapeProspect({required String id, required String etape}) async {
    try {
      final result = await supabase
          .from(AppTables.prospects)
          .update({AppTables.colEtape: etape})
          .eq(AppTables.colId, id)
          .select()
          .single();
      return ProspectModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Prospects] modifierEtapeProspect: $e\n$stack');
      throw const NetworkException();
    }
  }
}