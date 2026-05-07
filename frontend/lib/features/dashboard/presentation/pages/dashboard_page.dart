import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/format_helper.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.topbarGradient),
        ),
        title: const Text('Cockpit — Tableau de bord',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(dashboardProvider.notifier).charger(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => ref.read(authProvider.notifier).seDeconnecter(),
          ),
        ],
      ),
      body: state.when(
        initial:    () => const LoadingWidget(),
        chargement: () => const LoadingWidget(),
        erreur: (failure) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.secondary, size: 48),
              const SizedBox(height: 16),
              Text(
                failure.when(
                  serveur:     (msg) => msg,
                  reseau:      ()    => AppStrings.erreurReseau,
                  nonAutorise: ()    => 'Accès non autorisé',
                  nonTrouve:   ()    => 'Données introuvables',
                  validation:  (msg) => msg,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(dashboardProvider.notifier).charger(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        charge: (stats) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).charger(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Militants ---
                const Text('Militants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.4,
                  children: [
                    KpiCard(
                      titre:     'Total militants',
                      valeur:    '${stats.totalMilitants}',
                      icone:     Icons.people,
                      sousTitre: 'Objectif ${stats.objectifMilitants}',
                      evolution: '+${stats.nouveauxCeMois} ce mois',
                    ),
                    KpiCard(
                      titre:    'Répartition',
                      valeur:   '${FormatHelper.formaterPourcentage(stats.pourcentageHommes)} H',
                      icone:    Icons.bar_chart,
                      sousTitre: '${FormatHelper.formaterPourcentage(stats.pourcentageFemmes)} F',
                      gradient: AppColors.kpiOrGradient,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- Finances ---
                const Text('Finances',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.4,
                  children: [
                    KpiCard(
                      titre:    'Solde global',
                      valeur:   FormatHelper.formaterMontant(stats.soldeGlobal),
                      icone:    Icons.account_balance_wallet,
                      gradient: stats.soldeGlobal >= 0
                          ? AppColors.kpiVertGradient
                          : AppColors.kpiRougeGradient,
                    ),
                    KpiCard(
                      titre:     'Recouvrement',
                      valeur:    FormatHelper.formaterPourcentage(stats.tauxRecouvrement),
                      icone:     Icons.payments,
                      sousTitre: 'Objectif ${stats.objectifRecouvrement.toInt()} %',
                      gradient:  stats.tauxRecouvrement >= stats.objectifRecouvrement
                          ? AppColors.kpiVertGradient
                          : AppColors.kpiRougeGradient,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // --- Activité (à compléter avec les modules suivants) ---
                const Text('Activité',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.4,
                  children: [
                    KpiCard(
                      titre:   'Prospects actifs',
                      valeur:  '${stats.prospectsActifs}',
                      icone:   Icons.person_add,
                      gradient: AppColors.kpiOrGradient,
                    ),
                    KpiCard(
                      titre:   'Événements ce mois',
                      valeur:  '${stats.evenementsCeMois}',
                      icone:   Icons.event,
                      gradient: AppColors.kpiOrGradient,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
