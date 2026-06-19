import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../data/datasources/espace_militant_datasource_impl.dart';
import '../../data/repositories/espace_militant_repository_impl.dart';
import '../../domain/entities/espace_cotisation_mois.dart';
import '../../domain/entities/espace_finances_resume.dart';
import '../../domain/entities/espace_militant_info.dart';
import '../../domain/usecases/get_espace_cotisations.dart';
import '../../domain/usecases/get_espace_finances.dart';
import '../../domain/usecases/verifier_militant.dart';

part 'espace_militant_provider.freezed.dart';

@freezed
class EspaceMilitantState with _$EspaceMilitantState {
  const factory EspaceMilitantState.verification() = _Verification;
  const factory EspaceMilitantState.chargement() = _Chargement;
  const factory EspaceMilitantState.charge({
    required EspaceMilitantInfo militant,
    required List<EspaceCotisationMois> cotisations,
    required EspaceFinancesResume finances,
  }) = _Charge;
  const factory EspaceMilitantState.erreur({required String message}) =
      _Erreur;
}

final espaceMilitantProvider =
    StateNotifierProvider.autoDispose<EspaceMilitantNotifier, EspaceMilitantState>(
  (ref) {
    final client = Supabase.instance.client;
    final ds = EspaceMilitantDatasourceImpl(client);
    final repo = EspaceMilitantRepositoryImpl(ds);
    return EspaceMilitantNotifier(
      verifierMilitant: VerifierMilitant(repo),
      getCotisations: GetEspaceCotisations(repo),
      getFinances: GetEspaceFinances(repo),
    );
  },
);

class EspaceMilitantNotifier extends StateNotifier<EspaceMilitantState> {
  final VerifierMilitant _verifier;
  final GetEspaceCotisations _getCotisations;
  final GetEspaceFinances _getFinances;

  EspaceMilitantNotifier({
    required VerifierMilitant verifierMilitant,
    required GetEspaceCotisations getCotisations,
    required GetEspaceFinances getFinances,
  })  : _verifier = verifierMilitant,
        _getCotisations = getCotisations,
        _getFinances = getFinances,
        super(const EspaceMilitantState.verification());

  Future<void> verifier(String numeroCarte, String telephone) async {
    state = const EspaceMilitantState.chargement();

    final result = await _verifier(ParamsVerifierMilitant(
      numeroCarte: numeroCarte,
      telephone: telephone,
    ));

    await result.fold(
      (failure) async {
        state = EspaceMilitantState.erreur(
          message: failure.when(
            serveur: (m) => m,
            reseau: () => 'Erreur réseau',
            nonAutorise: () => 'Accès refusé',
            nonTrouve: () => 'Carte ou téléphone introuvable',
            validation: (m) => m,
          ),
        );
      },
      (militant) async {
        final results = await Future.wait([
          _getCotisations(
              ParamsEspaceCotisations(militantId: militant.militantId)),
          _getFinances(ParamsEspaceFinances(uniteId: militant.uniteId)),
        ]);

        final cotisations =
            results[0] as Either<Failure, List<EspaceCotisationMois>>;
        final finances = results[1] as Either<Failure, EspaceFinancesResume>;

        state = EspaceMilitantState.charge(
          militant: militant,
          cotisations: cotisations.getOrElse(() => []),
          finances: finances.getOrElse(() => const EspaceFinancesResume(
              celluleSolde: 0, celluleNbMembres: 0)),
        );
      },
    );
  }
}
