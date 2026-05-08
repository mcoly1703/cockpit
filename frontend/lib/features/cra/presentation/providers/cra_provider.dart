import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/cra_datasource.dart';
import '../../data/repositories/cra_repository_impl.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';

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

final craRepositoryProvider = Provider(
  (ref) => CraRepositoryImpl(ref.watch(craDatasourceProvider)),
);

// --- Notifier mes CR ---

final craProvider = StateNotifierProvider<CraNotifier, CraState>(
  (ref) => CraNotifier(repository: ref.watch(craRepositoryProvider), ref: ref),
);

class CraNotifier extends StateNotifier<CraState> {
  final CraRepository _repository;
  final Ref _ref;

  CraNotifier({required CraRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(const CraState.initial()) {
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
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const CraState.erreur(failure: Failure.nonAutorise());
      return;
    }
    final uniteId = utilisateur.uniteOrganisationnelleId ?? '';
    if (uniteId.isEmpty) {
      state = const CraState.charge(rendus: []);
      return;
    }
    final result = await _repository.getMesRendus(uniteId);
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
    final result = await _repository.creerCr(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> mettreAJour(ParamsMajCr params) async {
    final result = await _repository.mettreAJour(params);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> soumettre(String crId) async {
    final result = await _repository.soumettre(crId);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> supprimer(String crId) async {
    final result = await _repository.supprimer(crId);
    if (result.isRight()) await charger();
    return result;
  }
}

// --- Notifier CR reçus (pour les superviseurs) ---

final craRecusProvider = StateNotifierProvider<CraRecusNotifier, CraRecusState>(
  (ref) => CraRecusNotifier(repository: ref.watch(craRepositoryProvider)),
);

class CraRecusNotifier extends StateNotifier<CraRecusState> {
  final CraRepository _repository;

  CraRecusNotifier({required CraRepository repository})
      : _repository = repository,
        super(const CraRecusState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const CraRecusState.chargement();
    final result = await _repository.getRendusRecus();
    result.fold(
      (f) => state = CraRecusState.erreur(failure: f),
      (r) => state = CraRecusState.charge(rendus: r),
    );
  }

  Future<Either<Failure, void>> valider(String crId) async {
    final result = await _repository.valider(crId);
    if (result.isRight()) await charger();
    return result;
  }

  Future<Either<Failure, void>> retourner(String crId, String observations) async {
    final result = await _repository.retourner(crId, observations);
    if (result.isRight()) await charger();
    return result;
  }
}