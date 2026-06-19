import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/espace_cotisation_mois.dart';
import '../../domain/entities/espace_finances_resume.dart';
import '../../domain/entities/espace_militant_info.dart';
import 'espace_militant_datasource.dart';

class EspaceMilitantDatasourceImpl implements EspaceMilitantDatasource {
  final SupabaseClient supabase;
  EspaceMilitantDatasourceImpl(this.supabase);

  @override
  Future<EspaceMilitantInfo> verifierMilitant({
    required String numeroCarte,
    required String telephone,
  }) async {
    try {
      final data = await supabase.rpc('get_espace_militant', params: {
        'p_numero_carte': numeroCarte,
        'p_telephone': telephone,
      });
      if (data == null) {
        throw const ServerException(
            message: 'Numéro de carte ou téléphone incorrect');
      }
      final j = data as Map<String, dynamic>;
      return EspaceMilitantInfo(
        militantId: j['militant_id'] as String,
        nom: j['nom'] as String,
        prenom: j['prenom'] as String,
        numeroCarte: j['numero_carte'] as String,
        statut: j['statut'] as String,
        dateAdhesion: DateTime.parse(j['date_adhesion'] as String),
        uniteId: j['unite_id'] as String,
        uniteNom: j['unite_nom'] as String? ?? '',
        uniteType: j['unite_type'] as String? ?? '',
        parentUniteId: j['parent_unite_id'] as String?,
        parentUniteNom: j['parent_unite_nom'] as String?,
        parentUniteType: j['parent_unite_type'] as String?,
      );
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<List<EspaceCotisationMois>> getCotisations({
    required String militantId,
  }) async {
    try {
      final data = await supabase.rpc('get_espace_cotisations', params: {
        'p_militant_id': militantId,
      });
      if (data == null) return [];
      return (data as List).map((j) {
        final m = j as Map<String, dynamic>;
        return EspaceCotisationMois(
          mois: m['mois'] as int,
          annee: m['annee'] as int,
          montantPaye: (m['montant_paye'] as num).toDouble(),
          montantDu: (m['montant_du'] as num?)?.toDouble(),
          statut: m['statut'] as String,
        );
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }

  @override
  Future<EspaceFinancesResume> getFinances({required String uniteId}) async {
    try {
      final data = await supabase.rpc('get_espace_finances', params: {
        'p_unite_id': uniteId,
      });
      final j = (data ?? {}) as Map<String, dynamic>;
      return EspaceFinancesResume(
        celluleSolde: (j['cellule_solde'] as num?)?.toDouble() ?? 0,
        celluleNbMembres: (j['cellule_nb_membres'] as num?)?.toInt() ?? 0,
        sousSectionId: j['sous_section_id'] as String?,
        sousSectionNom: j['sous_section_nom'] as String?,
        sousSectionSolde: (j['sous_section_solde'] as num?)?.toDouble(),
        sousSectionNbMembres:
            (j['sous_section_nb_membres'] as num?)?.toInt(),
      );
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (_) {
      throw const NetworkException();
    }
  }
}
