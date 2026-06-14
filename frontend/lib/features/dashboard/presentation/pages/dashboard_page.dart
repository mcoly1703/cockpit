import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/format_helper.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../rapports/presentation/pages/rapport_activite_form_page.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state       = ref.watch(dashboardProvider);
    final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);

    return state.when(
      initial:    () => const LoadingWidget(),
      chargement: () => const LoadingWidget(),
      erreur: (failure) => _ErreurView(
        message: failure.when(
          serveur:     (msg) => msg,
          reseau:      ()    => AppStrings.erreurReseau,
          nonAutorise: ()    => 'Accès non autorisé',
          nonTrouve:   ()    => 'Données introuvables',
          validation:  (msg) => msg,
        ),
        onRetry: () => ref.read(dashboardProvider.notifier).charger(),
      ),
      charge: (stats) => RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).charger(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(13, 13, 13, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bannière de bienvenue
              _WelcomeBanner(utilisateur: utilisateur),
              const SizedBox(height: 11),

              // Barre objectif 10 000
              _ObjectifBar(stats: stats),
              const SizedBox(height: 11),

              // 6 KPI cards
              _KpiGrid(stats: stats),
              const SizedBox(height: 11),

              // Détail cellules par section
              const _CellulesSection(),
              const SizedBox(height: 11),

              // Graphique évolution militants
              _GraphiqueCard(stats: stats),
              const SizedBox(height: 11),

              // Alertes dynamiques
              _Alertes(stats: stats),

              // Bouton rapport PDF
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RapportActiviteFormPage()),
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text("Rapport d'activité PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  ),
                ),
              ),
              const SizedBox(height: 11),

              // Prochains événements (placeholder)
              _ProchainEvenementsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- WELCOME BANNER ----------

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.utilisateur});
  final utilisateur;

  @override
  Widget build(BuildContext context) {
    final nom    = utilisateur != null
        ? '${utilisateur.prenom} ${utilisateur.nom}'
        : '—';
    final role   = utilisateur?.role ?? '';
    final date   = _formaterDate(DateTime.now());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          // Filigrane cercle décoratif
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BONJOUR',
                style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 2),
              Text(
                nom,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                role,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 7),
              Text(
                date,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formaterDate(DateTime d) {
    const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    const mois  = ['janvier','février','mars','avril','mai','juin','juillet','août','septembre','octobre','novembre','décembre'];
    return '${jours[d.weekday - 1]} ${d.day} ${mois[d.month - 1]} ${d.year}';
  }
}

// ---------- BARRE OBJECTIF ----------

class _ObjectifBar extends StatelessWidget {
  const _ObjectifBar({required this.stats});
  final stats;

  @override
  Widget build(BuildContext context) {
    final pct      = stats.objectifMilitants > 0
        ? (stats.totalMilitants / stats.objectifMilitants).clamp(0.0, 1.0)
        : 0.0;
    final pctLabel = '${(pct * 100).toStringAsFixed(0)}%';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Objectif 10 000 Militants France',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.text2),
              ),
              Text(
                pctLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${stats.totalMilitants} / ${stats.objectifMilitants}',
            style: const TextStyle(fontSize: 11, color: AppColors.text2),
          ),
          const SizedBox(height: 6),
          // Barre de progression dégradée
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 8, color: AppColors.border),
                FractionallySizedBox(
                  widthFactor: pct,
                  child: Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: AppColors.topbarGradient,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '+${stats.nouveauxCeMois} ce mois',
                style: const TextStyle(fontSize: 10, color: AppColors.text2),
              ),
              Text(
                '+${stats.nouveauxCetteAnnee} cette année',
                style: const TextStyle(fontSize: 10, color: AppColors.text2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- KPI GRID (2×3) ----------

class _KpiGrid extends ConsumerWidget {
  const _KpiGrid({required this.stats});
  final stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalActivites = ref.watch(totalActivitesProvider).when(
      data:    (n)    => n,
      loading: ()     => stats.evenementsCeMois,
      error:   (e, s) => stats.evenementsCeMois,
    );

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 9,
      mainAxisSpacing: 9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        KpiCard(
          titre:     'Militants',
          valeur:    '${stats.totalMilitants}',
          icone:     Icons.people_rounded,
          evolution: '+${stats.nouveauxCeMois} ce mois',
          emoji:     '🫂',
          gradient:  AppColors.kpiVertGradient,
        ),
        KpiCard(
          titre:     'Taux recouvrement',
          valeur:    FormatHelper.formaterPourcentage(stats.tauxRecouvrement),
          icone:     Icons.payments_rounded,
          evolution: '${FormatHelper.formaterMontant(stats.totalEntrees)} entrées',
          emoji:     '💰',
          gradient:  AppColors.kpiRougeGradient,
        ),
        KpiCard(
          titre:     'Prospects',
          valeur:    '${stats.prospectsActifs}',
          icone:     Icons.person_add_rounded,
          evolution: 'Conv. ${FormatHelper.formaterPourcentage(stats.tauxConversion)}',
          emoji:     '📋',
          gradient:  AppColors.kpiBleuGradient,
        ),
        KpiCard(
          titre:     'Actions retard',
          valeur:    '${stats.actionsEnRetard}',
          icone:     Icons.warning_rounded,
          evolution: 'À traiter',
          emoji:     '⚡',
          gradient:  AppColors.kpiDarkGradient,
        ),
        KpiCard(
          titre:     'Cellules',
          valeur:    '${stats.nombreCellules}',
          icone:     Icons.location_city_rounded,
          evolution: 'Total actives',
          emoji:     '🏘️',
          gradient:  AppColors.kpiVioletGradient,
        ),
        KpiCard(
          titre:     'Activités',
          valeur:    '$totalActivites',
          icone:     Icons.event_rounded,
          evolution: '${stats.evenementsCeMois} ce mois',
          emoji:     '📅',
          gradient:  AppColors.kpiOrGradient,
        ),
      ],
    );
  }
}

// ---------- GRAPHIQUE ----------

class _GraphiqueCard extends StatelessWidget {
  const _GraphiqueCard({required this.stats});
  final stats;

  @override
  Widget build(BuildContext context) {
    final points = stats.evolutionMilitants as List;
    if (points.isEmpty) return const SizedBox.shrink();

    final spots = points.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.valeur);
    }).toList();

    final maxY = points.fold(0.0, (m, p) => p.valeur > m ? p.valeur : m) * 1.2;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ÉVOLUTION MILITANTS — 6 MOIS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.text2),
          ),
          const SizedBox(height: 11),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY > 0 ? maxY : 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (value != idx.toDouble()) return const SizedBox.shrink();
                        if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                        final mois = (points[idx].mois as DateTime).month;
                        const labels = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
                        return Text(labels[mois], style: const TextStyle(fontSize: 9, color: AppColors.text2));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- ALERTES DYNAMIQUES ----------

class _Alertes extends StatelessWidget {
  const _Alertes({required this.stats});
  final stats;

  @override
  Widget build(BuildContext context) {
    // Actions en retard — rouge si > 0, vert si aucune
    final actionsOk = stats.actionsEnRetard == 0;
    final alerteActions = _AlerteData(
      type:    actionsOk ? 'vert' : 'rouge',
      message: actionsOk
          ? 'Aucune action en retard'
          : '${stats.actionsEnRetard} action(s) en retard — à traiter',
      detail:  actionsOk
          ? 'Toutes les décisions sont à jour'
          : 'Vérifiez les décisions en attente',
    );

    // Taux de recouvrement — orange si sous objectif, vert si atteint
    final tauxOk = stats.tauxRecouvrement >= stats.objectifRecouvrement;
    final alerteRecouvrement = _AlerteData(
      type:    tauxOk ? 'vert' : 'orange',
      message: tauxOk
          ? 'Recouvrement ${FormatHelper.formaterPourcentage(stats.tauxRecouvrement)} — objectif atteint'
          : 'Recouvrement ${FormatHelper.formaterPourcentage(stats.tauxRecouvrement)} — en dessous de l\'objectif',
      detail:  'Objectif : ${stats.objectifRecouvrement.toInt()}%',
    );

    // Nouveaux militants — toujours affiché
    final alerteMilitants = _AlerteData(
      type:    stats.nouveauxCeMois > 0 ? 'vert' : 'orange',
      message: stats.nouveauxCeMois > 0
          ? '+${stats.nouveauxCeMois} nouveaux militants ce mois'
          : 'Aucun nouveau militant ce mois',
      detail:  '+${stats.nouveauxCetteAnnee} cette année · Objectif ${stats.objectifMilitants}',
    );

    return Column(
      children: [
        _AlerteItem(data: alerteActions),
        _AlerteItem(data: alerteRecouvrement),
        _AlerteItem(data: alerteMilitants),
        const SizedBox(height: 11),
      ],
    );
  }
}

class _AlerteData {
  const _AlerteData({required this.type, required this.message, required this.detail});
  final String type;
  final String message;
  final String detail;
}

class _AlerteItem extends StatelessWidget {
  const _AlerteItem({required this.data});
  final _AlerteData data;

  @override
  Widget build(BuildContext context) {
    final (couleur, bg) = switch (data.type) {
      'rouge'  => (AppColors.secondary, AppColors.alerteRougeBg),
      'orange' => (AppColors.accent,    AppColors.alerteOrangeBg),
      _        => (AppColors.primary,   AppColors.alerteVertBg),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(11),
        border: Border(left: BorderSide(color: couleur, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.message, style: const TextStyle(fontSize: 12, color: AppColors.text, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(data.detail, style: const TextStyle(fontSize: 10, color: AppColors.text2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- PROCHAINS ÉVÉNEMENTS ----------

class _ProchainEvenementsCard extends StatelessWidget {
  const _ProchainEvenementsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROCHAINS ÉVÉNEMENTS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.text2),
              ),
              Text(
                'Voir →',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 11),
          const Center(
            child: Text(
              'Module événements à venir',
              style: TextStyle(fontSize: 12, color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- VUE ERREUR ----------

class _ErreurView extends StatelessWidget {
  const _ErreurView({required this.message, required this.onRetry});
  final String   message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.secondary, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.text2)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- CELLULES PAR SECTION / ACTIVITÉS PAR CELLULE ----------

class _CellulesSection extends ConsumerWidget {
  const _CellulesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final estSS = utilisateur?.role == AppRoles.responsableSousSection;

    if (estSS) {
      return _ActivitesParCellule(ref: ref);
    }
    return _CellulesParSection(ref: ref);
  }
}

class _CellulesParSection extends StatelessWidget {
  const _CellulesParSection({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(cellulesParSectionProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error:   (e, s) => const SizedBox.shrink(),
      data: (parSection) {
        if (parSection.isEmpty) return const SizedBox.shrink();
        final total = parSection.values.fold(0, (a, b) => a + b);
        return _BreakdownCard(
          titre:  'CELLULES PAR SECTION',
          badge:  '$total au total',
          lignes: parSection.entries.map((e) => _LigneBar(
            nom:    e.key,
            valeur: '${e.value} cellule${e.value > 1 ? 's' : ''}',
            ratio:  total > 0 ? e.value / total : 0,
          )).toList(),
        );
      },
    );
  }
}

class _ActivitesParCellule extends StatelessWidget {
  const _ActivitesParCellule({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(activitesParCelluleProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error:   (e, s) => const SizedBox.shrink(),
      data: (parCellule) {
        if (parCellule.isEmpty) return const SizedBox.shrink();
        final total = parCellule.values.fold(0, (a, b) => a + b);
        return _BreakdownCard(
          titre:  'ACTIVITÉS PAR CELLULE',
          badge:  '$total activités',
          lignes: parCellule.entries.map((e) => _LigneBar(
            nom:    e.key,
            valeur: '${e.value} activité${e.value > 1 ? 's' : ''}',
            ratio:  total > 0 ? e.value / total : 0,
          )).toList(),
        );
      },
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.titre, required this.badge, required this.lignes});
  final String        titre;
  final String        badge;
  final List<_LigneBar> lignes;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      boxShadow: AppColors.cardShadow,
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_city_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(titre, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(badge, style: const TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...lignes,
      ],
    ),
  );
}

class _LigneBar extends StatelessWidget {
  const _LigneBar({required this.nom, required this.valeur, required this.ratio});
  final String nom;
  final String valeur;
  final double ratio;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(nom,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
            ),
            Text(valeur,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 5,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    ),
  );
}