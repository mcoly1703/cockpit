import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/reunions_datasource_impl.dart';
import '../../data/repositories/reunions_repository_impl.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/reunion.dart';
import '../../domain/usecases/ajouter_decision.dart';
import '../../domain/usecases/ajouter_reunion.dart';
import '../../domain/usecases/get_decisions.dart';
import '../../domain/usecases/get_reunions.dart';
import '../../domain/usecases/modifier_statut_decision.dart';

part 'reunions_provider.freezed.dart';

// --- État reunions ---

@freezed
class ReunionsState with _$ReunionsState {
  const ReunionsState._();

  const factory ReunionsState.initial()                               = _Initial;
  const factory ReunionsState.chargement()                            = _Chargement;
  const factory ReunionsState.charge({required List<Reunion> reunions}) = _Charge;
  const factory ReunionsState.erreur({required Failure failure})      = _Erreur;

  List<Reunion> get toutes => maybeWhen(
        charge: (r) => List<Reunion>.from(r)
          ..sort((a, b) => b.date.compareTo(a.date)),
        orElse: () => [],
      );

  List<Reunion> get aVenir => maybeWhen(
        charge: (r) => r.where((re) => re.date.isAfter(DateTime.now())).toList()
          ..sort((a, b) => a.date.compareTo(b.date)),
        orElse: () => [],
      );

  List<Reunion> get terminees => maybeWhen(
        charge: (r) => r.where((re) => !re.date.isAfter(DateTime.now())).toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
        orElse: () => [],
      );

  int get total => maybeWhen(charge: (r) => r.length, orElse: () => 0);
}

// --- État decisions ---

@freezed
class DecisionsState with _$DecisionsState {
  const DecisionsState._();

  const factory DecisionsState.initial()                                  = _DInitial;
  const factory DecisionsState.chargement()                               = _DChargement;
  const factory DecisionsState.charge({required List<Decision> decisions}) = _DCharge;
  const factory DecisionsState.erreur({required Failure failure})         = _DErreur;

  int countParStatut(String statut) => maybeWhen(
        charge: (d) => d.where((dec) => dec.statut == statut).length,
        orElse: () => 0,
      );

  int get enAttente  => countParStatut(AppEnums.decisionEnAttente);
  int get enCours    => countParStatut(AppEnums.decisionEnCours);
  int get terminees  => countParStatut(AppEnums.decisionTerminee);
}

// --- Providers d'infrastructure ---

final reunionsDatasourceProvider = Provider(
  (ref) => ReunionsDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final reunionsRepositoryProvider = Provider(
  (ref) => ReunionsRepositoryImpl(ref.watch(reunionsDatasourceProvider)),
);

// --- Notifier reunions ---

final reunionsProvider = StateNotifierProvider<ReunionsNotifier, ReunionsState>(
  (ref) => ReunionsNotifier(
    getReunions:    GetReunions(ref.watch(reunionsRepositoryProvider)),
    ajouterReunion: AjouterReunion(ref.watch(reunionsRepositoryProvider)),
    ref: ref,
  ),
);

class ReunionsNotifier extends StateNotifier<ReunionsState> {
  final GetReunions    _getReunions;
  final AjouterReunion _ajouterReunion;
  final Ref            _ref;

  ReunionsNotifier({
    required GetReunions getReunions,
    required AjouterReunion ajouterReunion,
    required Ref ref,
  })  : _getReunions = getReunions,
        _ajouterReunion = ajouterReunion,
        _ref = ref,
        super(const ReunionsState.initial()) {
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const ReunionsState.chargement();
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const ReunionsState.erreur(failure: Failure.nonAutorise());
      return;
    }
    final filtrer = !_estAccesGlobal(utilisateur.role);
    final uniteId = filtrer ? utilisateur.uniteOrganisationnelleId : null;

    final result = await _getReunions(ParamsGetReunions(uniteId: uniteId));
    result.fold(
      (f) => state = ReunionsState.erreur(failure: f),
      (r) => state = ReunionsState.charge(reunions: r),
    );
  }

  Future<Either<Failure, void>> ajouterReunion(ParamsAjouterReunion params) async {
    final result = await _ajouterReunion(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }
}

// --- Notifier decisions ---

final decisionsProvider = StateNotifierProvider.family<DecisionsNotifier, DecisionsState, String>(
  (ref, reunionId) => DecisionsNotifier(
    getDecisions:          GetDecisions(ref.watch(reunionsRepositoryProvider)),
    ajouterDecision:       AjouterDecision(ref.watch(reunionsRepositoryProvider)),
    modifierStatut:        ModifierStatutDecision(ref.watch(reunionsRepositoryProvider)),
    reunionId:             reunionId,
  ),
);

class DecisionsNotifier extends StateNotifier<DecisionsState> {
  final GetDecisions          _getDecisions;
  final AjouterDecision       _ajouterDecision;
  final ModifierStatutDecision _modifierStatut;
  final String                _reunionId;

  DecisionsNotifier({
    required GetDecisions getDecisions,
    required AjouterDecision ajouterDecision,
    required ModifierStatutDecision modifierStatut,
    required String reunionId,
  })  : _getDecisions = getDecisions,
        _ajouterDecision = ajouterDecision,
        _modifierStatut = modifierStatut,
        _reunionId = reunionId,
        super(const DecisionsState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const DecisionsState.chargement();
    final result = await _getDecisions(_reunionId);
    result.fold(
      (f) => state = DecisionsState.erreur(failure: f),
      (d) => state = DecisionsState.charge(decisions: d),
    );
  }

  Future<Either<Failure, void>> ajouterDecision(ParamsAjouterDecision params) async {
    final result = await _ajouterDecision(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }

  Future<Either<Failure, void>> modifierStatut(String id, String statut) async {
    final result = await _modifierStatut(ParamsModifierStatutDecision(id: id, statut: statut));
    if (result.isRight()) {
      state.maybeWhen(
        charge: (decisions) {
          final updated = decisions
              .map((d) => d.id == id ? d.copyWith(statut: statut) : d)
              .toList();
          state = DecisionsState.charge(decisions: updated);
        },
        orElse: () {},
      );
    }
    return result.map((_) {});
  }
}