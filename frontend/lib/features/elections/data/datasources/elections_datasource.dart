import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/candidat_election.dart';
import '../../domain/entities/scrutin.dart';
import '../../domain/repositories/elections_repository.dart';

class ElectionsDatasource {
  final SupabaseClient supabase;
  ElectionsDatasource(this.supabase);

  Future<List<Scrutin>> getScrutins({String? uniteId}) async {
    try {
      var query = supabase.from(AppTables.scrutins).select();
      if (uniteId != null) {
        query = query.eq(AppTables.colUniteId, uniteId);
      }
      final data = await query.order(AppTables.colDateScrutin);
      return data.map(_scrutinFromMap).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<List<CandidatElection>> getCandidats(String scrutinId) async {
    try {
      final data = await supabase
          .from(AppTables.candidatsElection)
          .select()
          .eq(AppTables.colScrutinId, scrutinId)
          .order(AppTables.colNom);
      return data.map(_candidatFromMap).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> ajouterScrutin(ParamsAjouterScrutin params) async {
    try {
      final row = <String, dynamic>{
        AppTables.colTitre:       params.titre,
        AppTables.colType:        params.type,
        AppTables.colDateScrutin: params.dateScrutin.toIso8601String().split('T').first,
        AppTables.colStatut:      AppEnums.scrutinEnPreparation,
      };
      if (params.uniteId != null)    row[AppTables.colUniteId]    = params.uniteId;
      if (params.description != null) row[AppTables.colDescription] = params.description;
      await supabase.from(AppTables.scrutins).insert(row);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> changerStatut(String scrutinId, String statut) async {
    try {
      await supabase
          .from(AppTables.scrutins)
          .update({AppTables.colStatut: statut})
          .eq(AppTables.colId, scrutinId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> ajouterCandidat(ParamsAjouterCandidat params) async {
    try {
      final row = <String, dynamic>{
        AppTables.colScrutinId: params.scrutinId,
        AppTables.colNom:       params.nom,
        AppTables.colPrenom:    params.prenom,
      };
      if (params.militantId != null) row[AppTables.colMilitantId] = params.militantId;
      if (params.poste != null)      row[AppTables.colPoste]      = params.poste;
      await supabase.from(AppTables.candidatsElection).insert(row);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> saisirResultat(ParamsSaisirResultat params) async {
    try {
      await supabase
          .from(AppTables.candidatsElection)
          .update({AppTables.colVoix: params.voix, AppTables.colElu: params.elu})
          .eq(AppTables.colId, params.candidatId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> retirerCandidat(String candidatId) async {
    try {
      await supabase
          .from(AppTables.candidatsElection)
          .delete()
          .eq(AppTables.colId, candidatId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  static Scrutin _scrutinFromMap(Map<String, dynamic> e) => Scrutin(
    id:          e[AppTables.colId]          as String,
    uniteId:     e[AppTables.colUniteId]     as String?,
    titre:       e[AppTables.colTitre]       as String,
    type:        e[AppTables.colType]        as String,
    dateScrutin: DateTime.parse(e[AppTables.colDateScrutin] as String),
    description: e[AppTables.colDescription] as String?,
    statut:      e[AppTables.colStatut]      as String,
  );

  static CandidatElection _candidatFromMap(Map<String, dynamic> e) => CandidatElection(
    id:         e[AppTables.colId]         as String,
    scrutinId:  e[AppTables.colScrutinId]  as String,
    militantId: e[AppTables.colMilitantId] as String?,
    nom:        e[AppTables.colNom]        as String,
    prenom:     e[AppTables.colPrenom]     as String,
    poste:      e[AppTables.colPoste]      as String?,
    voix:       e[AppTables.colVoix]       as int?,
    elu:        (e[AppTables.colElu]       as bool?) ?? false,
  );
}