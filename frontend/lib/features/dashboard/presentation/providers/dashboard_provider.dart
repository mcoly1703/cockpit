import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
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

// --- Provider total activités (événements) ---

final totalActivitesProvider = FutureProvider<int>((ref) async {
  final client      = ref.watch(supabaseClientProvider);
  final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
  if (utilisateur == null) return 0;

  final estGlobal = utilisateur.role == AppRoles.bureauExecutif ||
                    utilisateur.role == AppRoles.coordinateur  ||
                    utilisateur.role == AppRoles.adminTechnique;

  var query = client.from(AppTables.evenements).select('id');
  if (!estGlobal && utilisateur.uniteOrganisationnelleId != null) {
    query = query.eq(AppTables.colUniteId, utilisateur.uniteOrganisationnelleId!);
  }
  final data = await query;
  return (data as List).length;
});

// --- Provider activités par cellule (vue sous-section) ---

final activitesParCelluleProvider = FutureProvider<Map<String, int>>((ref) async {
  final client      = ref.watch(supabaseClientProvider);
  final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
  if (utilisateur?.uniteOrganisationnelleId == null) return {};

  final cellules = await client
      .from(AppTables.unitesOrganisationnelles)
      .select('id, nom')
      .eq(AppTables.colType, AppUniteTypes.cellule)
      .eq(AppTables.colParentId, utilisateur!.uniteOrganisationnelleId!);

  if ((cellules as List).isEmpty) return {};

  final celluleIds = cellules.map((c) => c['id'] as String).toList();

  final events = await client
      .from(AppTables.evenements)
      .select(AppTables.colUniteId)
      .inFilter(AppTables.colUniteId, celluleIds);

  final Map<String, int> countById = {};
  for (final e in (events as List)) {
    final uid = e[AppTables.colUniteId] as String;
    countById[uid] = (countById[uid] ?? 0) + 1;
  }

  final Map<String, int> result = {
    for (final c in cellules)
      c['nom'] as String: countById[c['id'] as String] ?? 0,
  };

  return Map.fromEntries(
    result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
});

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

// --- Provider statuts cellules (en_creation / active / pleine) ---

typedef CellulesStatut = ({int enCreation, int active, int pleines});

final cellulesStatutProvider = FutureProvider<CellulesStatut>((ref) async {
  final client      = ref.watch(supabaseClientProvider);
  final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
  if (utilisateur == null) return (enCreation: 0, active: 0, pleines: 0);

  final estGlobal = utilisateur.role == AppRoles.bureauExecutif ||
                    utilisateur.role == AppRoles.coordinateur  ||
                    utilisateur.role == AppRoles.adminTechnique;

  var cellulesQuery = client
      .from(AppTables.unitesOrganisationnelles)
      .select(AppTables.colId)
      .eq(AppTables.colType, AppUniteTypes.cellule)
      .eq(AppTables.colIsActive, true);
  if (!estGlobal && utilisateur.uniteOrganisationnelleId != null) {
    cellulesQuery = cellulesQuery.eq(
      AppTables.colParentId,
      utilisateur.uniteOrganisationnelleId!,
    );
  }
  final cellules = await cellulesQuery;
  final celluleIds = (cellules as List).map((c) => c[AppTables.colId] as String).toList();
  if (celluleIds.isEmpty) return (enCreation: 0, active: 0, pleines: 0);

  final militants = await client
      .from(AppTables.militants)
      .select(AppTables.colUniteId)
      .eq(AppTables.colStatut, AppEnums.militantActif)
      .inFilter(AppTables.colUniteId, celluleIds);

  final countParId = <String, int>{};
  for (final m in militants as List) {
    final uid = m[AppTables.colUniteId] as String;
    countParId[uid] = (countParId[uid] ?? 0) + 1;
  }

  int enCreation = 0, active = 0, pleines = 0;
  for (final id in celluleIds) {
    final n = countParId[id] ?? 0;
    if (n >= AppConstants.seuilPleineCellule)      { pleines++; }
    else if (n >= AppConstants.seuilActiveCellule) { active++; }
    else                                           { enCreation++; }
  }
  return (enCreation: enCreation, active: active, pleines: pleines);
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
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => charger());
    });
    charger();
  }

  Future<void> charger() async {
    state = const DashboardState.chargement();

    final authState   = _ref.read(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (user) => user);

    if (utilisateur == null) {
      final enAttente = authState.whenOrNull(initial: () => true, chargement: () => true) ?? false;
      if (!enAttente) { state = const DashboardState.erreur(failure: Failure.nonAutorise()); }
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