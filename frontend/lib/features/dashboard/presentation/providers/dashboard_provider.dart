import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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