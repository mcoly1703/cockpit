import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/prospects_datasource_impl.dart';
import '../../data/repositories/prospects_repository_impl.dart';
import '../../domain/entities/prospect.dart';
import '../../domain/usecases/ajouter_prospect.dart';
import '../../domain/usecases/get_prospects.dart';
import '../../domain/usecases/modifier_etape_prospect.dart';

part 'prospects_provider.freezed.dart';

// --- État ---

@freezed
class ProspectsState with _$ProspectsState {
  const ProspectsState._();

  const factory ProspectsState.initial()                              = _Initial;
  const factory ProspectsState.chargement()                          = _Chargement;
  const factory ProspectsState.charge({required List<Prospect> prospects}) = _Charge;
  const factory ProspectsState.erreur({required Failure failure})    = _Erreur;

  List<Prospect> parEtape(String etape) => maybeWhen(
        charge: (p) => p.where((pr) => pr.etape == etape).toList(),
        orElse: () => [],
      );

  int countParEtape(String etape) => maybeWhen(
        charge: (p) => p.where((pr) => pr.etape == etape).length,
        orElse: () => 0,
      );

  int get total => maybeWhen(charge: (p) => p.length, orElse: () => 0);

  double get tauxConversion => maybeWhen(
        charge: (p) {
          if (p.isEmpty) return 0;
          final convertis = p.where((pr) => pr.etape == AppEnums.etapeConverti).length;
          return convertis / p.length * 100;
        },
        orElse: () => 0,
      );
}

// --- Providers d'infrastructure ---

final prospectsDatasourceProvider = Provider(
  (ref) => ProspectsDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final prospectsRepositoryProvider = Provider(
  (ref) => ProspectsRepositoryImpl(ref.watch(prospectsDatasourceProvider)),
);

// --- Notifier ---

final prospectsProvider = StateNotifierProvider<ProspectsNotifier, ProspectsState>(
  (ref) => ProspectsNotifier(
    getProspects:        GetProspects(ref.watch(prospectsRepositoryProvider)),
    ajouterProspect:     AjouterProspect(ref.watch(prospectsRepositoryProvider)),
    modifierEtape:       ModifierEtapeProspect(ref.watch(prospectsRepositoryProvider)),
    ref: ref,
  ),
);

class ProspectsNotifier extends StateNotifier<ProspectsState> {
  final GetProspects        _getProspects;
  final AjouterProspect     _ajouterProspect;
  final ModifierEtapeProspect _modifierEtape;
  final Ref                 _ref;

  ProspectsNotifier({
    required GetProspects getProspects,
    required AjouterProspect ajouterProspect,
    required ModifierEtapeProspect modifierEtape,
    required Ref ref,
  })  : _getProspects = getProspects,
        _ajouterProspect = ajouterProspect,
        _modifierEtape = modifierEtape,
        _ref = ref,
        super(const ProspectsState.initial()) {
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const ProspectsState.chargement();

    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const ProspectsState.erreur(failure: Failure.nonAutorise());
      return;
    }

    final filtrer = !_estAccesGlobal(utilisateur.role);
    final uniteId = filtrer ? utilisateur.uniteOrganisationnelleId : null;

    final result = await _getProspects(ParamsGetProspects(uniteId: uniteId));
    result.fold(
      (failure) => state = ProspectsState.erreur(failure: failure),
      (prospects) => state = ProspectsState.charge(prospects: prospects),
    );
  }

  Future<Either<Failure, void>> ajouterProspect(ParamsAjouterProspect params) async {
    final result = await _ajouterProspect(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }

  Future<Either<Failure, void>> modifierEtape(String id, String etape) async {
    final result = await _modifierEtape(ParamsModifierEtape(id: id, etape: etape));
    if (result.isRight()) {
      state.maybeWhen(
        charge: (prospects) {
          final updated = prospects.map((p) => p.id == id ? p.copyWith(etape: etape) : p).toList();
          state = ProspectsState.charge(prospects: updated);
        },
        orElse: () {},
      );
    }
    return result.map((_) {});
  }
}