import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/dashboard_datasource_impl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/usecases/get_dashboard_stats.dart';

part 'dashboard_provider.freezed.dart';

// --- État ---

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial()                               = DashboardInitial;
  const factory DashboardState.chargement()                            = DashboardChargement;
  const factory DashboardState.charge({required DashboardStats stats}) = DashboardCharge;
  const factory DashboardState.erreur({required Failure failure})      = DashboardErreur;
}

// --- Providers d'infrastructure ---

final dashboardDatasourceProvider = Provider(
  (ref) => DashboardDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepositoryImpl(ref.watch(dashboardDatasourceProvider)),
);

// --- Notifier ---

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>(
  (ref) => DashboardNotifier(
    getDashboardStats: GetDashboardStats(ref.watch(dashboardRepositoryProvider)),
    ref: ref,
  ),
);

// --- Provider cellules par section ---

final cellulesParSectionProvider = FutureProvider<Map<String, int>>((ref) async {
  final client      = ref.watch(supabaseClientProvider);
  final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
  if (utilisateur == null) return {};

  final estGlobal = utilisateur.role == AppRoles.bureauExecutif ||
                    utilisateur.role == AppRoles.coordinateur  ||
                    utilisateur.role == AppRoles.adminTechnique;

  // Récupère les cellules (filtrées par parent_id si vue locale)
  var cellulesQuery = client
      .from(AppTables.unitesOrganisationnelles)
      .select('nom, parent_id')
      .eq(AppTables.colType, AppUniteTypes.cellule);
  if (!estGlobal && utilisateur.uniteOrganisationnelleId != null) {
    cellulesQuery = cellulesQuery.eq(
      AppTables.colParentId,
      utilisateur.uniteOrganisationnelleId!,
    );
  }
  final cellules = await cellulesQuery;

  // Récupère les noms des sous-sections pour le mapping parent_id → nom
  final sections = await client
      .from(AppTables.unitesOrganisationnelles)
      .select('id, nom')
      .eq(AppTables.colType, AppUniteTypes.sousSection);

  final Map<String, String> nomParId = {
    for (final s in sections) s['id'] as String: s['nom'] as String,
  };

  final Map<String, int> result = {};
  for (final c in cellules) {
    final parentId = c['parent_id'] as String?;
    final sectionNom = parentId != null ? (nomParId[parentId] ?? parentId) : '—';
    result[sectionNom] = (result[sectionNom] ?? 0) + 1;
  }

  // Trier par nombre décroissant
  return Map.fromEntries(
    result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardStats _getDashboardStats;
  final Ref _ref;

  DashboardNotifier({
    required GetDashboardStats getDashboardStats,
    required Ref ref,
  })  : _getDashboardStats = getDashboardStats,
        _ref = ref,
        super(const DashboardState.initial()) {
    charger();
  }

  Future<void> charger() async {
    state = const DashboardState.chargement();

    final authState   = _ref.read(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (user) => user);

    if (utilisateur == null) {
      state = const DashboardState.erreur(failure: Failure.nonAutorise());
      return;
    }

    final result = await _getDashboardStats(
      ParamsGetDashboardStats(
        role:    utilisateur.role,
        uniteId: utilisateur.uniteOrganisationnelleId,
      ),
    );

    result.fold(
      (failure) => state = DashboardState.erreur(failure: failure),
      (stats)   => state = DashboardState.charge(stats: stats),
    );
  }
}