import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/reunion.dart';
import '../../domain/repositories/reunions_repository.dart';
import '../models/decision_model.dart';
import '../models/reunion_model.dart';
import 'reunions_datasource.dart';

class ReunionsDatasourceImpl implements ReunionsDatasource {
  final SupabaseClient supabase;
  ReunionsDatasourceImpl(this.supabase);

  @override
  Future<List<Reunion>> getReunions({String? uniteId}) async {
    try {
      var query = supabase.from(AppTables.reunions).select();
      if (uniteId != null) query = query.eq(AppTables.colUniteId, uniteId);
      final data = await query.order(AppTables.colDate, ascending: false);
      return data.map((e) => ReunionModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Reunions] getReunions: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Reunion> ajouterReunion(ParamsAjouterReunion params) async {
    try {
      final result = await supabase
          .from(AppTables.reunions)
          .insert({
            AppTables.colTitre:      params.titre,
            AppTables.colType:       params.type,
            AppTables.colDate:       params.date.toIso8601String(),
            AppTables.colLieu:       params.lieu,
            if (params.ordreJour != null)
              AppTables.colOrdreJour: params.ordreJour,
            AppTables.colUniteId:    params.uniteId,
            AppTables.colCreatedBy:  supabase.auth.currentUser!.id,
          })
          .select()
          .single();
      return ReunionModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Reunions] ajouterReunion: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<List<Decision>> getDecisions(String reunionId) async {
    try {
      final data = await supabase
          .from(AppTables.decisions)
          .select()
          .eq(AppTables.colReunionId, reunionId)
          .order(AppTables.colCreatedAt);
      return data.map((e) => DecisionModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Reunions] getDecisions: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Decision> ajouterDecision(ParamsAjouterDecision params) async {
    try {
      final result = await supabase
          .from(AppTables.decisions)
          .insert({
            AppTables.colReunionId:   params.reunionId,
            AppTables.colTexte:       params.texte,
            if (params.responsable != null)
              AppTables.colResponsable: params.responsable,
            if (params.echeance != null)
              AppTables.colEcheance:  params.echeance!.toIso8601String().substring(0, 10),
            AppTables.colStatut:      AppEnums.decisionEnAttente,
          })
          .select()
          .single();
      return DecisionModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Reunions] ajouterDecision: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Decision> modifierStatutDecision({required String id, required String statut}) async {
    try {
      final result = await supabase
          .from(AppTables.decisions)
          .update({AppTables.colStatut: statut})
          .eq(AppTables.colId, id)
          .select()
          .single();
      return DecisionModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Reunions] modifierStatutDecision: $e\n$stack');
      throw const NetworkException();
    }
  }
}