import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/elections_datasource.dart';
import '../../data/repositories/elections_repository_impl.dart';
import '../../domain/entities/candidat_election.dart';
import '../../domain/entities/scrutin.dart';
import '../../domain/repositories/elections_repository.dart';

part 'elections_provider.freezed.dart';

// --- États ---

@freezed
class ElectionsState with _$ElectionsState {
  const ElectionsState._();

  const factory ElectionsState.initial()                                   = _Initial;
  const factory ElectionsState.chargement()                                = _Chargement;
  const factory ElectionsState.charge({required List<Scrutin> scrutins})   = _Charge;
  const factory ElectionsState.erreur({required Failure failure})           = _Erreur;

  List<Scrutin> get aVenir => maybeWhen(
        charge: (s) => s
            .where((sc) =>
                sc.statut != AppEnums.scrutinClos &&
                !sc.dateScrutin.isBefore(DateTime.now().subtract(const Duration(days: 1))))
            .toList(),
        orElse: () => [],
      );

  List<Scrutin> get passes => maybeWhen(
        charge: (s) => s
            .where((sc) =>
                sc.statut == AppEnums.scrutinClos ||
                sc.dateScrutin.isBefore(DateTime.now()))
            .toList(),
        orElse: () => [],
      );
}

@freezed
class CandidatsState with _$CandidatsState {
  const factory CandidatsState.initial()                                            = _CInitial;
  const factory CandidatsState.chargement()                                         = _CChargement;
  const factory CandidatsState.charge({required List<CandidatElection> candidats}) = _CCharge;
  const factory CandidatsState.erreur({required Failure failure})                   = _CErreur;
}

// --- Providers d'infrastructure ---

final electionsDatasourceProvider = Provider(
  (ref) => ElectionsDatasource(ref.watch(supabaseClientProvider)),
);

final electionsRepositoryProvider = Provider(
  (ref) => ElectionsRepositoryImpl(ref.watch(electionsDatasourceProvider)),
);

// --- Notifier scrutins ---

final electionsProvider =
    StateNotifierProvider<ElectionsNotifier, ElectionsState>(
  (ref) => ElectionsNotifier(
    repository: ref.watch(electionsRepositoryProvider),
    ref: ref,
  ),
);

class ElectionsNotifier extends StateNotifier<ElectionsState> {
  final ElectionsRepository _repository;
  final Ref _ref;

  ElectionsNotifier({required ElectionsRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(const ElectionsState.initial()) {
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const ElectionsState.chargement();
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const ElectionsState.erreur(failure: Failure.nonAutorise());
      return;
    }
    final filtrer = !_estAccesGlobal(utilisateur.role);
    final uniteId = filtrer ? utilisateur.uniteOrganisationnelleId : null;
    final result = await _repository.getScrutins(uniteId: uniteId);
    result.fold(
      (f) => state = ElectionsState.erreur(failure: f),
      (s) => state = ElectionsState.charge(scrutins: s),
    );
  }

  Future<Either<Failure, void>> ajouterScrutin(ParamsAjouterScrutin params) async {
    final result = await _repository.ajouterScrutin(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> changerStatut(String scrutinId, String statut) async {
    final result = await _repository.changerStatut(scrutinId, statut);
    if (result.isRight()) await charger();
    return result;
  }
}

// --- Notifier candidats (par scrutin) ---

final candidatsProvider = StateNotifierProvider.family<CandidatsNotifier, CandidatsState, String>(
  (ref, scrutinId) => CandidatsNotifier(
    repository: ref.watch(electionsRepositoryProvider),
    scrutinId: scrutinId,
  ),
);

class CandidatsNotifier extends StateNotifier<CandidatsState> {
  final ElectionsRepository _repository;
  final String _scrutinId;

  CandidatsNotifier({required ElectionsRepository repository, required String scrutinId})
      : _repository = repository,
        _scrutinId = scrutinId,
        super(const CandidatsState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const CandidatsState.chargement();
    final result = await _repository.getCandidats(_scrutinId);
    result.fold(
      (f) => state = CandidatsState.erreur(failure: f),
      (c) => state = CandidatsState.charge(candidats: c),
    );
  }

  Future<Either<Failure, void>> ajouterCandidat(ParamsAjouterCandidat params) async {
    final result = await _repository.ajouterCandidat(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> saisirResultat(ParamsSaisirResultat params) async {
    final result = await _repository.saisirResultat(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> retirerCandidat(String candidatId) async {
    final result = await _repository.retirerCandidat(candidatId);
    if (result.isRight()) await charger();
    return result;
  }
}