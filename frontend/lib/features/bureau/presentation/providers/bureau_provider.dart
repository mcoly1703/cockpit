import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/bureau_datasource_impl.dart';
import '../../data/repositories/bureau_repository_impl.dart';
import '../../domain/entities/poste_bureau.dart';
import '../../domain/repositories/bureau_repository.dart';
import '../../domain/usecases/get_postes_bureau.dart';
import '../../domain/usecases/nommer_membre.dart';
import '../../domain/usecases/retirer_membre.dart';
import '../../domain/usecases/search_militants_bureau.dart';

part 'bureau_provider.freezed.dart';

// --- État ---

@freezed
class BureauState with _$BureauState {
  const BureauState._();

  const factory BureauState.initial()                                    = _Initial;
  const factory BureauState.chargement()                                 = _Chargement;
  const factory BureauState.charge({required List<PosteBureau> postes})  = _Charge;
  const factory BureauState.erreur({required Failure failure})           = _Erreur;

  int get totalPourvus => maybeWhen(charge: (p) => p.length, orElse: () => 0);

  List<String> get intitulesOccupes => maybeWhen(
        charge: (p) => p.map((e) => e.intitule).toList(),
        orElse: () => [],
      );

  PosteBureau? posteParIntitule(String intitule) => maybeWhen(
        charge: (p) => p.cast<PosteBureau?>().firstWhere(
              (e) => e!.intitule == intitule,
              orElse: () => null,
            ),
        orElse: () => null,
      );
}

// --- Providers d'infrastructure ---

final bureauDatasourceProvider = Provider(
  (ref) => BureauDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final bureauRepositoryProvider = Provider(
  (ref) => BureauRepositoryImpl(ref.watch(bureauDatasourceProvider)),
);

// --- Notifier ---

final bureauProvider = StateNotifierProvider<BureauNotifier, BureauState>(
  (ref) => BureauNotifier(
    getPostesBureau:      GetPostesBureau(ref.watch(bureauRepositoryProvider)),
    nommerMembre:         NommerMembre(ref.watch(bureauRepositoryProvider)),
    retirerMembre:        RetirerMembre(ref.watch(bureauRepositoryProvider)),
    searchMilitants:      SearchMilitantsBureau(ref.watch(bureauRepositoryProvider)),
    ref: ref,
  ),
);

class BureauNotifier extends StateNotifier<BureauState> {
  final GetPostesBureau    _getPostesBureau;
  final NommerMembre       _nommerMembre;
  final RetirerMembre      _retirerMembre;
  final SearchMilitantsBureau _searchMilitants;
  final Ref                _ref;

  BureauNotifier({
    required GetPostesBureau getPostesBureau,
    required NommerMembre nommerMembre,
    required RetirerMembre retirerMembre,
    required SearchMilitantsBureau searchMilitants,
    required Ref ref,
  })  : _getPostesBureau = getPostesBureau,
        _nommerMembre = nommerMembre,
        _retirerMembre = retirerMembre,
        _searchMilitants = searchMilitants,
        _ref = ref,
        super(const BureauState.initial()) {
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => charger());
    });
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const BureauState.chargement();
    final authState   = _ref.read(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      final enAttente = authState.whenOrNull(initial: () => true, chargement: () => true) ?? false;
      if (!enAttente) { state = const BureauState.erreur(failure: Failure.nonAutorise()); }
      return;
    }
    final uniteId = utilisateur.uniteOrganisationnelleId;
    if (uniteId == null) {
      state = const BureauState.charge(postes: []);
      return;
    }
    final result = await _getPostesBureau(uniteId);
    result.fold(
      (f) => state = BureauState.erreur(failure: f),
      (p) => state = BureauState.charge(postes: p),
    );
  }

  Future<Either<Failure, void>> nommerMembre(ParamsNommerMembre params) async {
    final result = await _nommerMembre(params);
    if (result.isRight()) {
      result.fold(
        (_) {},
        (poste) => state.maybeWhen(
          charge: (postes) {
            final updated = postes.where((p) => p.intitule != poste.intitule).toList()
              ..add(poste);
            state = BureauState.charge(postes: updated);
          },
          orElse: () => charger(),
        ),
      );
    }
    return result.map((_) {});
  }

  Future<Either<Failure, void>> retirerMembre(String id) async {
    final result = await _retirerMembre(id);
    if (result.isRight()) {
      state.maybeWhen(
        charge: (postes) {
          state = BureauState.charge(
              postes: postes.where((p) => p.id != id).toList());
        },
        orElse: () {},
      );
    }
    return result;
  }

  Future<Either<Failure, List<MilitantResume>>> searchMilitants(
      String query) async {
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    final uniteId = utilisateur?.uniteOrganisationnelleId ?? '';
    return _searchMilitants(query, uniteId);
  }

  bool estAccesGlobal() {
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    return utilisateur != null && _estAccesGlobal(utilisateur.role);
  }

  List<(String, String)> getListePostes() {
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) return AppEnums.postesLocaux;
    return _estAccesGlobal(utilisateur.role)
        ? AppEnums.postesExecutif
        : AppEnums.postesLocaux;
  }
}