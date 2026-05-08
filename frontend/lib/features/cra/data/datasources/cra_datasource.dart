import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';

class CraDatasource {
  final SupabaseClient supabase;
  CraDatasource(this.supabase);

  Future<List<CompteRendu>> getMesRendus(String uniteId) async {
    try {
      final data = await supabase
          .from(AppTables.compteRendus)
          .select('*, unites_organisationnelles(code)')
          .eq(AppTables.colUniteId, uniteId)
          .order(AppTables.colAnnee, ascending: false)
          .order(AppTables.colMois, ascending: false);
      return data.map(_fromMap).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<List<CompteRendu>> getRendusRecus() async {
    try {
      final data = await supabase
          .from(AppTables.compteRendus)
          .select('*, unites_organisationnelles(code)')
          .eq(AppTables.colStatut, AppEnums.craSoumis)
          .order(AppTables.colSoumisAt, ascending: false);
      return data.map(_fromMap).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> creerCr(ParamsCreerCr params) async {
    try {
      final row = <String, dynamic>{
        AppTables.colUniteId:                params.uniteId,
        AppTables.colMois:                   params.mois,
        AppTables.colAnnee:                  params.annee,
        AppTables.colDescriptionActivites:   params.descriptionActivites,
        AppTables.colNouveauxContacts:       params.nouveauxContacts,
        AppTables.colEvenementsTenus:        params.evenementsTenus,
        AppTables.colPresencesTotal:         params.presencesTotal,
        AppTables.colCotisationsCollectees:  params.cotisationsCollectees,
        AppTables.colStatut:                 AppEnums.craBrouillon,
      };
      if (params.difficultes != null) row[AppTables.colDifficultes] = params.difficultes;
      await supabase.from(AppTables.compteRendus).insert(row);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> mettreAJour(ParamsMajCr params) async {
    try {
      final row = <String, dynamic>{
        AppTables.colDescriptionActivites:  params.descriptionActivites,
        AppTables.colNouveauxContacts:      params.nouveauxContacts,
        AppTables.colEvenementsTenus:       params.evenementsTenus,
        AppTables.colPresencesTotal:        params.presencesTotal,
        AppTables.colCotisationsCollectees: params.cotisationsCollectees,
        AppTables.colDifficultes:           params.difficultes,
      };
      await supabase
          .from(AppTables.compteRendus)
          .update(row)
          .eq(AppTables.colId, params.id);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> soumettre(String crId) async {
    try {
      await supabase.from(AppTables.compteRendus).update({
        AppTables.colStatut:   AppEnums.craSoumis,
        AppTables.colSoumisAt: DateTime.now().toIso8601String(),
      }).eq(AppTables.colId, crId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> valider(String crId) async {
    try {
      await supabase.from(AppTables.compteRendus).update({
        AppTables.colStatut:   AppEnums.craValide,
        AppTables.colValideAt: DateTime.now().toIso8601String(),
      }).eq(AppTables.colId, crId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> retourner(String crId, String observations) async {
    try {
      await supabase.from(AppTables.compteRendus).update({
        AppTables.colStatut:           AppEnums.craRetourne,
        AppTables.colObservationsCoord: observations,
      }).eq(AppTables.colId, crId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  Future<void> supprimer(String crId) async {
    try {
      await supabase
          .from(AppTables.compteRendus)
          .delete()
          .eq(AppTables.colId, crId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  static CompteRendu _fromMap(Map<String, dynamic> e) {
    final uniteData = e['unites_organisationnelles'] as Map<String, dynamic>?;
    return CompteRendu(
      id:                    e[AppTables.colId]                    as String,
      uniteId:               e[AppTables.colUniteId]               as String,
      uniteCode:             uniteData?['code']                    as String?,
      mois:                  e[AppTables.colMois]                  as int,
      annee:                 e[AppTables.colAnnee]                 as int,
      statut:                e[AppTables.colStatut]                as String,
      descriptionActivites:  e[AppTables.colDescriptionActivites]  as String,
      nouveauxContacts:      e[AppTables.colNouveauxContacts]      as int,
      evenementsTenus:       e[AppTables.colEvenementsTenus]       as int,
      presencesTotal:        e[AppTables.colPresencesTotal]        as int,
      cotisationsCollectees: (e[AppTables.colCotisationsCollectees] as num).toDouble(),
      difficultes:           e[AppTables.colDifficultes]           as String?,
      observationsCoord:     e[AppTables.colObservationsCoord]     as String?,
      soumisAt:    e[AppTables.colSoumisAt]  != null
          ? DateTime.parse(e[AppTables.colSoumisAt] as String) : null,
      valideAt:    e[AppTables.colValideAt]  != null
          ? DateTime.parse(e[AppTables.colValideAt]  as String) : null,
      createdAt: DateTime.parse(e[AppTables.colCreatedAt] as String),
    );
  }
}