import 'package:supabase_flutter/supabase_flutter.dart' hide Presence;

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/evenement.dart';
import '../../domain/entities/presence.dart';
import '../../domain/repositories/evenements_repository.dart';
import '../models/evenement_model.dart';
import '../models/presence_model.dart';
import 'evenements_datasource.dart';

class EvenementsDatasourceImpl implements EvenementsDatasource {
  final SupabaseClient supabase;
  EvenementsDatasourceImpl(this.supabase);

  @override
  Future<List<Evenement>> getEvenements({String? uniteId}) async {
    try {
      var query = supabase.from(AppTables.evenements).select();
      if (uniteId != null) query = query.eq(AppTables.colUniteId, uniteId);

      final data = await query.order(AppTables.colDateDebut, ascending: false);
      return data.map((e) => EvenementModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Evenements] getEvenements: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Evenement> ajouterEvenement(ParamsAjouterEvenement params) async {
    try {
      final result = await supabase
          .from(AppTables.evenements)
          .insert({
            AppTables.colTitre:    params.titre,
            if (params.description != null)
              AppTables.colDescription: params.description,
            AppTables.colDateDebut:  params.dateDebut.toIso8601String(),
            if (params.dateFin != null)
              AppTables.colDateFin:  params.dateFin!.toIso8601String(),
            AppTables.colLieu:       params.lieu,
            AppTables.colType:       params.type,
            AppTables.colUniteId:    params.uniteId,
            AppTables.colCreatedBy:  supabase.auth.currentUser!.id,
          })
          .select()
          .single();
      return EvenementModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Evenements] ajouterEvenement: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<List<Presence>> getPresences(String evenementId) async {
    try {
      final data = await supabase
          .from(AppTables.presences)
          .select()
          .eq(AppTables.colEvenementId, evenementId)
          .order(AppTables.colCheckedAt);
      return data.map((e) => PresenceModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Evenements] getPresences: $e\n$stack');
      throw const NetworkException();
    }
  }

  @override
  Future<Presence> enregistrerPresence(ParamsEnregistrerPresence params) async {
    try {
      final result = await supabase
          .from(AppTables.presences)
          .insert({
            AppTables.colEvenementId: params.evenementId,
            if (params.militantId != null)
              AppTables.colMilitantId: params.militantId,
            AppTables.colNom:         params.nom,
            AppTables.colPrenom:      params.prenom,
            if (params.telephone != null)
              AppTables.colTelephone:  params.telephone,
          })
          .select()
          .single();
      return PresenceModel.fromJson(result).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e, stack) {
      // ignore: avoid_print
      print('[Evenements] enregistrerPresence: $e\n$stack');
      throw const NetworkException();
    }
  }
}