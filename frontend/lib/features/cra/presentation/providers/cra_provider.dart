import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/cra_datasource.dart';
import '../../data/repositories/cra_repository_impl.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';
import '../../domain/usecases/creer_cr.dart';
import '../../domain/usecases/get_mes_rendus.dart';
import '../../domain/usecases/get_rendus_recus.dart';
import '../../domain/usecases/mettre_a_jour_cr.dart';
import '../../domain/usecases/retourner_cr.dart';
import '../../domain/usecases/soumettre_cr.dart';
import '../../domain/usecases/supprimer_cr.dart';
import '../../domain/usecases/valider_cr.dart';

part 'cra_provider.freezed.dart';

// --- États ---

@freezed
class CraState with _$CraState {
  const CraState._();

  const factory CraState.initial()                                             = _Initial;
  const factory CraState.chargement()                                          = _Chargement;
  const factory CraState.charge({required List<CompteRendu> rendus})           = _Charge;
  const factory CraState.erreur({required Failure failure})                    = _Erreur;

  List<CompteRendu> get brouillons => maybeWhen(
        charge: (r) => r.where((c) => c.statut == AppEnums.craBrouillon ||
            c.statut == AppEnums.craRetourne).toList(),
        orElse: () => [],
      );

  List<CompteRendu> get soumis => maybeWhen(
        charge: (r) => r.where((c) => c.statut == AppEnums.craSoumis).toList(),
        orElse: () => [],
      );

  List<CompteRendu> get valides => maybeWhen(
        charge: (r) => r.where((c) => c.statut == AppEnums.craValide).toList(),
        orElse: () => [],
      );
}

@freezed
class CraRecusState with _$CraRecusState {
  const factory CraRecusState.initial()                                        = _RInitial;
  const factory CraRecusState.chargement()                                     = _RChargement;
  const factory CraRecusState.charge({required List<CompteRendu> rendus})      = _RCharge;
  const factory CraRecusState.erreur({required Failure failure})               = _RErreur;
}

// --- Providers d'infrastructure ---

final craDatasourceProvider = Provider(
  (ref) => CraDatasource(ref.watch(supabaseClientProvider)),
);

final craRepositoryProvider = Provider<CraRepository>(
  (ref) => CraRepositoryImpl(ref.watch(craDatasourceProvider)),
);

// --- Notifier mes CR ---

final craProvider = StateNotifierProvider<CraNotifier, CraState>(
  (ref) => CraNotifier(
    getMesRendus:  GetMesRendus(ref.watch(craRepositoryProvider)),
    creerCr:       CreerCr(ref.watch(craRepositoryProvider)),
    mettreAJour:   MettreAJourCr(ref.watch(craRepositoryProvider)),
    soumettre:     SoumettreC(ref.watch(craRepositoryProvider)),
    supprimer:     SupprimerCr(ref.watch(craRepositoryProvider)),
    ref:           ref,
  ),
);

class CraNotifier extends StateNotifier<CraState> {
  final GetMesRendus  _getMesRendus;
  final CreerCr       _creerCr;
  final MettreAJourCr _mettreAJour;
  final SoumettreC    _soumettre;
  final SupprimerCr   _supprimer;
  final Ref           _ref;

  CraNotifier({
    required GetMesRendus  getMesRendus,
    required CreerCr       creerCr,
    required MettreAJourCr mettreAJour,
    required SoumettreC    soumettre,
    required SupprimerCr   supprimer,
    required Ref           ref,
  })  : _getMesRendus = getMesRendus,
        _creerCr      = creerCr,
        _mettreAJour  = mettreAJour,
        _soumettre    = soumettre,
        _supprimer    = supprimer,
        _ref          = ref,
        super(const CraState.initial()) {
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => charger());
    });
    charger();
  }

  bool _estSuperviseur(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.responsableSousSection ||
      role == AppRoles.responsableMouvement ||
      role == AppRoles.responsableSecretariat ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const CraState.chargement();
    final authState   = _ref.read(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      final enAttente = authState.whenOrNull(initial: () => true, chargement: () => true) ?? false;
      if (!enAttente) { state = const CraState.erreur(failure: Failure.nonAutorise()); }
      return;
    }
    final uniteId = utilisateur.uniteOrganisationnelleId ?? '';
    if (uniteId.isEmpty) {
      state = const CraState.charge(rendus: []);
      return;
    }
    final result = await _getMesRendus(uniteId);
    result.fold(
      (f) => state = CraState.erreur(failure: f),
      (r) => state = CraState.charge(rendus: r),
    );
  }

  bool estSuperviseur() {
    final u = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    return u != null && _estSuperviseur(u.role);
  }

  Future<Either<Failure, void>> creerCr(ParamsCreerCr params) async {
    final result = await _creerCr(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> mettreAJour(ParamsMajCr params) async {
    final result = await _mettreAJour(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> soumettre(String crId) async {
    final result = await _soumettre(crId);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> supprimer(String crId) async {
    final result = await _supprimer(crId);
    if (result.isRight()) await charger();
    return result;
  }
}

// --- Notifier CR reçus (pour les superviseurs) ---

final craRecusProvider = StateNotifierProvider<CraRecusNotifier, CraRecusState>(
  (ref) => CraRecusNotifier(
    getRendusRecus: GetRendusRecus(ref.watch(craRepositoryProvider)),
    validerCr:      ValiderCr(ref.watch(craRepositoryProvider)),
    retournerCr:    RetournerCr(ref.watch(craRepositoryProvider)),
    ref:            ref,
  ),
);

class CraRecusNotifier extends StateNotifier<CraRecusState> {
  final GetRendusRecus _getRendusRecus;
  final ValiderCr      _validerCr;
  final RetournerCr    _retournerCr;
  final Ref            _ref;

  CraRecusNotifier({
    required GetRendusRecus getRendusRecus,
    required ValiderCr      validerCr,
    required RetournerCr    retournerCr,
    required Ref            ref,
  })  : _getRendusRecus = getRendusRecus,
        _validerCr      = validerCr,
        _retournerCr    = retournerCr,
        _ref            = ref,
        super(const CraRecusState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const CraRecusState.chargement();
    final result = await _getRendusRecus(const NoParams());
    result.fold(
      (f) => state = CraRecusState.erreur(failure: f),
      (r) => state = CraRecusState.charge(rendus: r),
    );
  }

  Future<Either<Failure, void>> valider(String crId) async {
    final result = await _validerCr(crId);
    if (result.isRight()) {
      await charger();
      await _ref.read(craProvider.notifier).charger();
    }
    return result;
  }

  Future<Either<Failure, void>> retourner(String crId, String observations) async {
    final result = await _retournerCr(
      ParamsRetournerCr(crId: crId, observations: observations),
    );
    if (result.isRight()) {
      await charger();
      await _ref.read(craProvider.notifier).charger();
    }
    return result;
  }
}