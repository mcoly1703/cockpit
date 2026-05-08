import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/cotisation.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finances_repository.dart';
import '../models/cotisation_model.dart';
import '../models/transaction_model.dart';
import 'finances_datasource.dart';

class FinancesDatasourceImpl implements FinancesDatasource {
  final SupabaseClient supabase;
  FinancesDatasourceImpl(this.supabase);

  @override
  Future<List<Transaction>> getTransactions({String? uniteId}) async {
    try {
      var query = supabase.from(AppTables.transactions).select('*');
      if (uniteId != null) query = query.eq(AppTables.colUniteId, uniteId);
      final data = await query.order(AppTables.colDateTransaction, ascending: false);
      return (data as List).map((e) => TransactionModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<Cotisation>> getCotisations({String? uniteId, int? annee}) async {
    try {
      // Sans join complexe : on charge toutes les cotisations filtrées par année,
      // le filtrage par unité est géré côté RLS Supabase selon le rôle de l'utilisateur.
      var query = supabase.from(AppTables.cotisations).select('*');
      if (annee != null) query = query.eq(AppTables.colAnnee, annee);
      final data = await query.order(AppTables.colAnnee, ascending: false);
      return (data as List).map((e) => CotisationModel.fromJson(e).toEntity()).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<Transaction> ajouterTransaction(ParamsAjouterTransaction params) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from(AppTables.transactions).insert({
        AppTables.colType:           params.type,
        AppTables.colCategorie:      params.categorie,
        AppTables.colMontant:        params.montant,
        AppTables.colDateTransaction: params.dateTransaction.toIso8601String().substring(0, 10),
        AppTables.colUniteId:        params.uniteId,
        AppTables.colDescription:    params.description,
        AppTables.colBeneficiaire:   params.beneficiaire,
        AppTables.colMilitantId:     params.militantId,
        AppTables.colCreatedBy:      userId,
      }).select().single();
      return TransactionModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<Cotisation> enregistrerCotisation(ParamsEnregistrerCotisation params) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from(AppTables.cotisations).upsert({
        AppTables.colMilitantId:    params.militantId,
        AppTables.colAnnee:         params.annee,
        AppTables.colMontant:       params.montant,
        AppTables.colStatutCotis:   params.statut,
        AppTables.colDatePaiement:  params.datePaiement?.toIso8601String().substring(0, 10),
        AppTables.colCreatedBy:     userId,
      }, onConflict: 'militant_id,annee').select().single();
      return CotisationModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }
}