import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/evenements_datasource_impl.dart';
import '../../data/repositories/evenements_repository_impl.dart';
import '../../domain/entities/evenement.dart';
import '../../domain/entities/presence.dart';
import '../../domain/usecases/ajouter_evenement.dart';
import '../../domain/usecases/enregistrer_presence.dart';
import '../../domain/usecases/get_evenements.dart';
import '../../domain/usecases/get_presences.dart';

part 'evenements_provider.freezed.dart';

// --- État liste événements ---

@freezed
class EvenementsState with _$EvenementsState {
  const EvenementsState._();

  const factory EvenementsState.initial()                                  = _Initial;
  const factory EvenementsState.chargement()                               = _Chargement;
  const factory EvenementsState.charge({required List<Evenement> evenements}) = _Charge;
  const factory EvenementsState.erreur({required Failure failure})         = _Erreur;

  List<Evenement> get aVenir => maybeWhen(
        charge: (e) => e.where((ev) => ev.dateDebut.isAfter(DateTime.now())).toList()
          ..sort((a, b) => a.dateDebut.compareTo(b.dateDebut)),
        orElse: () => [],
      );

  List<Evenement> get passes => maybeWhen(
        charge: (e) => e.where((ev) => !ev.dateDebut.isAfter(DateTime.now())).toList(),
        orElse: () => [],
      );

  int get total => maybeWhen(charge: (e) => e.length, orElse: () => 0);
}

// --- État présences (par événement) ---

@freezed
class PresencesState with _$PresencesState {
  const factory PresencesState.initial()                                 = _PInitial;
  const factory PresencesState.chargement()                              = _PChargement;
  const factory PresencesState.charge({required List<Presence> presences}) = _PCharge;
  const factory PresencesState.erreur({required Failure failure})        = _PErreur;
}

// --- Providers d'infrastructure ---

final evenementsDatasourceProvider = Provider(
  (ref) => EvenementsDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final evenementsRepositoryProvider = Provider(
  (ref) => EvenementsRepositoryImpl(ref.watch(evenementsDatasourceProvider)),
);

// --- Notifier événements ---

final evenementsProvider = StateNotifierProvider<EvenementsNotifier, EvenementsState>(
  (ref) => EvenementsNotifier(
    getEvenements:   GetEvenements(ref.watch(evenementsRepositoryProvider)),
    ajouterEvenement: AjouterEvenement(ref.watch(evenementsRepositoryProvider)),
    ref: ref,
  ),
);

class EvenementsNotifier extends StateNotifier<EvenementsState> {
  final GetEvenements    _getEvenements;
  final AjouterEvenement _ajouterEvenement;
  final Ref              _ref;

  EvenementsNotifier({
    required GetEvenements getEvenements,
    required AjouterEvenement ajouterEvenement,
    required Ref ref,
  })  : _getEvenements = getEvenements,
        _ajouterEvenement = ajouterEvenement,
        _ref = ref,
        super(const EvenementsState.initial()) {
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const EvenementsState.chargement();

    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const EvenementsState.erreur(failure: Failure.nonAutorise());
      return;
    }

    final filtrer = !_estAccesGlobal(utilisateur.role);
    final uniteId = filtrer ? utilisateur.uniteOrganisationnelleId : null;

    final result = await _getEvenements(ParamsGetEvenements(uniteId: uniteId));
    result.fold(
      (failure) => state = EvenementsState.erreur(failure: failure),
      (evenements) => state = EvenementsState.charge(evenements: evenements),
    );
  }

  Future<Either<Failure, void>> ajouterEvenement(ParamsAjouterEvenement params) async {
    final result = await _ajouterEvenement(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }
}

// --- Notifier présences (par événement) ---

final presencesProvider = StateNotifierProvider.family<PresencesNotifier, PresencesState, String>(
  (ref, evenementId) => PresencesNotifier(
    getPresences:        GetPresences(ref.watch(evenementsRepositoryProvider)),
    enregistrerPresence: EnregistrerPresence(ref.watch(evenementsRepositoryProvider)),
    evenementId:         evenementId,
  ),
);

class PresencesNotifier extends StateNotifier<PresencesState> {
  final GetPresences        _getPresences;
  final EnregistrerPresence _enregistrerPresence;
  final String              _evenementId;

  PresencesNotifier({
    required GetPresences getPresences,
    required EnregistrerPresence enregistrerPresence,
    required String evenementId,
  })  : _getPresences = getPresences,
        _enregistrerPresence = enregistrerPresence,
        _evenementId = evenementId,
        super(const PresencesState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const PresencesState.chargement();
    final result = await _getPresences(_evenementId);
    result.fold(
      (f) => state = PresencesState.erreur(failure: f),
      (p) => state = PresencesState.charge(presences: p),
    );
  }

  Future<Either<Failure, void>> enregistrerPresence(ParamsEnregistrerPresence params) async {
    final result = await _enregistrerPresence(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }
}