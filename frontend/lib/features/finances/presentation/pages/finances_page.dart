import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../militants/presentation/providers/militants_provider.dart';
import '../../domain/repositories/finances_repository.dart';
import '../providers/finances_provider.dart';
import 'transaction_form_page.dart';

// ─── Page principale ──────────────────────────────────────────────────────────

class FinancesPage extends ConsumerWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state    = ref.watch(financesProvider);
    final milState = ref.watch(militantsProvider);

    return state.when(
      initial:    () => const SizedBox.shrink(),
      chargement: () => const Center(child: CircularProgressIndicator()),
      erreur: (f) => _ErreurVue(
        message: f.when(
          serveur:     (m) => m,
          reseau:      () => 'Pas de connexion réseau',
          nonAutorise: () => 'Accès non autorisé',
          nonTrouve:   () => 'Données introuvables',
          validation:  (m) => m,
        ),
        onRetry: () => ref.read(financesProvider.notifier).charger(),
      ),
      charge: (transactions, cotisations) => _PageContenu(
        state:        state,
        milState:     milState,
        transactions: transactions,
      ),
    );
  }
}

// ─── Contenu ──────────────────────────────────────────────────────────────────

class _PageContenu extends ConsumerStatefulWidget {
  const _PageContenu({
    required this.state,
    required this.milState,
    required this.transactions,
  });
  final FinancesState   state;
  final MilitantsState  milState;
  final List            transactions;

  @override
  ConsumerState<_PageContenu> createState() => _PageContenuState();
}

class _PageContenuState extends ConsumerState<_PageContenu> {
  // null = Entrées (défaut), 'depense', 'ss'
  // 'entree' | 'depense' | 'ss'
  String _filtreChip = AppEnums.transactionEntree;

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.secondary : AppColors.primary,
    ));
  }

  // Calcule le taux de recouvrement par SS en croisant finances + militants
  List<(String, int, int, double, String?)> _tauxParSS() {
    return widget.milState.maybeWhen(
      charge: (militants, unites, statsParSS, statsParCellule) {
        // Construire militant → SS
        final celSS = <String, String>{};
        for (final u in unites.where((u) => u.type == AppUniteTypes.cellule)) {
          if (u.parentId != null) celSS[u.id] = u.parentId!;
        }
        String? getSSId(String uniteId) {
          final u = unites.firstWhere((u) => u.id == uniteId,
              orElse: () => unites.first);
          if (u.type == AppUniteTypes.sousSection) return uniteId;
          if (u.type == AppUniteTypes.cellule) return celSS[uniteId];
          return null;
        }
        final milToSS = <String, String>{};
        for (final m in militants) {
          final ss = getSSId(m.uniteId);
          if (ss != null) milToSS[m.id] = ss;
        }
        // Compter militants distincts ayant au moins 1 mois payé, par SS
        final payeesSet = <String, Set<String>>{};
        final totauxSet = <String, Set<String>>{};
        widget.state.maybeWhen(
          charge: (_, cotisations) {
            for (final c in cotisations) {
              final ss = milToSS[c.militantId];
              if (ss == null) continue;
              (totauxSet[ss] ??= {}).add(c.militantId);
              if (c.statut == AppEnums.cotisationPayee) {
                (payeesSet[ss] ??= {}).add(c.militantId);
              }
            }
          },
          orElse: () {},
        );
        final payees = payeesSet.map((k, v) => MapEntry(k, v.length));
        final totaux = totauxSet.map((k, v) => MapEntry(k, v.length));
        final sousSections =
            unites.where((u) => u.type == AppUniteTypes.sousSection).toList();
        final result = sousSections
            .where((ss) => (totaux[ss.id] ?? 0) > 0)
            .map((ss) {
              final p = payees[ss.id] ?? 0;
              final t = totaux[ss.id] ?? 1;
              return (ss.nom, p, t, p / t * 100, ss.code);
            })
            .toList();
        result.sort((a, b) => b.$4.compareTo(a.$4));
        return result;
      },
      orElse: () => <(String, int, int, double, String?)>[],
    );
  }

  // (nom, code, entrees, depenses) — toutes les SS, même sans transactions
  List<(String, String?, double, double)> _comparatifSS() {
    return widget.milState.maybeWhen(
      charge: (militants, unites, statsParSS, statsParCellule) {
        return widget.state.maybeWhen(
          charge: (txs, _) {
            final celSS = <String, String>{};
            for (final u in unites.where((u) => u.type == AppUniteTypes.cellule)) {
              if (u.parentId != null) celSS[u.id] = u.parentId!;
            }
            final result = unites
                .where((u) => u.type == AppUniteTypes.sousSection)
                .map((ss) {
                  final ids = <String>{
                    ss.id,
                    ...unites
                        .where((u) => u.type == AppUniteTypes.cellule && celSS[u.id] == ss.id)
                        .map((u) => u.id),
                  };
                  final e = txs
                      .where((t) => ids.contains(t.uniteId) && t.type == AppEnums.transactionEntree)
                      .fold(0.0, (s, t) => s + t.montant);
                  final d = txs
                      .where((t) => ids.contains(t.uniteId) && t.type == AppEnums.transactionDepense)
                      .fold(0.0, (s, t) => s + t.montant);
                  return (ss.nom, ss.code, e, d);
                })
                .toList()
              ..sort((a, b) => (b.$3 - b.$4).compareTo(a.$3 - a.$4));
            return result;
          },
          orElse: () => <(String, String?, double, double)>[],
        );
      },
      orElse: () => <(String, String?, double, double)>[],
    );
  }

  // (ssNom, ssCode, [(celNom, celCode, payees, total, taux%)]) — taux recouvrement par cellule
  List<(String, String?, List<(String, String?, int, int, double)>)> _tauxCotisParCellule() {
    return widget.milState.maybeWhen(
      charge: (militants, unites, statsParSS, statsParCellule) {
        return widget.state.maybeWhen(
          charge: (txs, cotisations) {
            final annee = DateTime.now().year;
            final ssMap = <String, (String, String?)>{
              for (final u in unites.where((u) => u.type == AppUniteTypes.sousSection))
                u.id: (u.nom, u.code),
            };
            // militant → cellule
            final milCel = <String, String>{
              for (final m in militants)
                if (unites.any((u) => u.id == m.uniteId && u.type == AppUniteTypes.cellule))
                  m.id: m.uniteId,
            };
            // compter militants distincts et ceux ayant au moins 1 mois payé, par cellule
            final totaux = <String, int>{};
            final payeesSet = <String, Set<String>>{};
            for (final m in militants) {
              if (milCel.containsKey(m.id)) totaux[m.uniteId] = (totaux[m.uniteId] ?? 0) + 1;
            }
            for (final c in cotisations.where((c) => c.annee == annee)) {
              final celId = milCel[c.militantId];
              if (celId == null) continue;
              if (c.statut == AppEnums.cotisationPayee) {
                (payeesSet[celId] ??= {}).add(c.militantId);
              }
            }
            final payees = payeesSet.map((k, v) => MapEntry(k, v.length));
            // grouper par SS — inclure toutes les cellules même sans militants
            final groupes = <String, List<(String, String?, int, int, double)>>{
              for (final ss in unites.where((u) => u.type == AppUniteTypes.sousSection))
                ss.id: [],
            };
            for (final cel in unites.where((u) => u.type == AppUniteTypes.cellule)) {
              final ssId = cel.parentId;
              if (ssId == null || !ssMap.containsKey(ssId)) continue;
              final t = totaux[cel.id] ?? 0;
              final p = payees[cel.id] ?? 0;
              final taux = t > 0 ? p / t * 100 : 0.0;
              (groupes[ssId] ??= []).add((cel.nom, cel.code, p, t, taux));
            }
            return groupes.entries
                .map((e) => (ssMap[e.key]!.$1, ssMap[e.key]!.$2, e.value))
                .toList()
              ..sort((a, b) => a.$1.compareTo(b.$1));
          },
          orElse: () => <(String, String?, List<(String, String?, int, int, double)>)>[],
        );
      },
      orElse: () => <(String, String?, List<(String, String?, int, int, double)>)>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final fmt   = NumberFormat.currency(locale: 'fr', symbol: '€', decimalDigits: 0);
    final annee = DateTime.now().year;
    final tauxSS = _tauxParSS();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Titre ──────────────────────────────────────────────────
          SliverToBoxAdapter(child: _TitrePage(annee: annee)),

          // ── Bloc taux de recouvrement ──────────────────────────────
          SliverToBoxAdapter(child: _BlocTauxRecouvrement(
            taux:       state.tauxRecouvrement,
            aJour:      state.cotisationsAJour,
            enRetard:   state.cotisationsEnRetard,
            enAttente:  state.cotisationsEnAttente,
            total:      state.totalCotisations,
          )),

          // ── KPIs Entrées / Dépenses ────────────────────────────────
          SliverToBoxAdapter(child: _KpiSection(
            totalEntrees:  state.totalEntrees,
            totalDepenses: state.totalDepenses,
            annee:         annee,
          )),

          // ── Solde global ───────────────────────────────────────────
          SliverToBoxAdapter(child: _BlocSolde(
            solde:         state.solde,
            totalEntrees:  state.totalEntrees,
            totalDepenses: state.totalDepenses,
            fmt:           fmt,
          )),

          // ── Graphique 6 mois ───────────────────────────────────────
          SliverToBoxAdapter(child: _GraphiqueEvolution(
            evolution: state.evolutionMensuelle,
          )),

          // ── Taux par SS ────────────────────────────────────────────
          if (tauxSS.isNotEmpty)
            SliverToBoxAdapter(child: _TauxParSS(taux: tauxSS)),

          // ── Chips filtre ───────────────────────────────────────────
          SliverToBoxAdapter(child: _FiltreChips(
            filtreActif: _filtreChip,
            onChanged:   (v) => setState(() => _filtreChip = v),
          )),

          // ── Diagramme catégories selon chip ──────────────────────
          if (_filtreChip == AppEnums.transactionEntree)
            SliverToBoxAdapter(child: _CategoriesBarChart(
              stats:    state.statsEntrees,
              isEntree: true,
            )),
          if (_filtreChip == AppEnums.transactionDepense)
            SliverToBoxAdapter(child: _CategoriesBarChart(
              stats:    state.statsDepenses,
              isEntree: false,
            )),

          // ── Taux recouvrement par cellule ──────────────────────────
          SliverToBoxAdapter(child: _ComparatifCellules(groupes: _tauxCotisParCellule())),

          // ── Comparatif par SS ─────────────────────────────────────
          SliverToBoxAdapter(child: _ComparatifSS(items: _comparatifSS())),

          // ── Bouton ajouter ─────────────────────────────────────────
          SliverToBoxAdapter(child: _BarreActions(
            onAjouter: () async {
              final notifier = ref.read(financesProvider.notifier);
              final result = await Navigator.of(context)
                  .push<ParamsAjouterTransaction>(
                MaterialPageRoute(builder: (_) => const TransactionFormPage()),
              );
              if (result != null && mounted) {
                final res = await notifier.ajouterTransaction(result);
                if (!mounted) return;
                res.fold(
                  (f) => _snack('Erreur lors de l\'enregistrement', isError: true),
                  (_) => _snack('Transaction enregistrée'),
                );
              }
            },
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Titre ────────────────────────────────────────────────────────────────────

class _TitrePage extends StatelessWidget {
  const _TitrePage({required this.annee});
  final int annee;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Finances',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.text)),
          Text('$annee',
              style: TextStyle(fontSize: 13, color: AppColors.text2)),
        ]),
      );
}

// ─── Bloc taux de recouvrement ────────────────────────────────────────────────

class _BlocTauxRecouvrement extends StatelessWidget {
  const _BlocTauxRecouvrement({
    required this.taux,
    required this.aJour,
    required this.enRetard,
    required this.enAttente,
    required this.total,
  });
  final double taux;
  final int    aJour;
  final int    enRetard;
  final int    enAttente;
  final int    total;

  @override
  Widget build(BuildContext context) {
    final pct = (taux / 100).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TAUX DE RECOUVREMENT',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: Colors.white70, letterSpacing: 0.8)),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${taux.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900,
                  color: Colors.white, height: 1)),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('$aJour / $total militants',
                style: const TextStyle(fontSize: 12, color: Colors.white,
                    fontWeight: FontWeight.w600)),
            Text('Objectif : ${AppConstants.objectifRecouvrement.toInt()}%',
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(children: [
            Container(height: 8, color: Colors.white24),
            FractionallySizedBox(
              widthFactor: pct,
              child: Container(height: 8, color: Colors.white),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Row(children: [
          _PuceStatut(couleur: const Color(0xFF4CAF50), label: 'À jour : $aJour'),
          const SizedBox(width: 14),
          _PuceStatut(couleur: AppColors.accent, label: 'Retard : $enRetard'),
          const SizedBox(width: 14),
          _PuceStatut(couleur: AppColors.secondary, label: 'En attente : $enAttente'),
        ]),
      ]),
    );
  }
}

class _PuceStatut extends StatelessWidget {
  const _PuceStatut({required this.couleur, required this.label});
  final Color  couleur;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(color: couleur, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ]);
}

// ─── KPIs ─────────────────────────────────────────────────────────────────────

class _KpiSection extends StatelessWidget {
  const _KpiSection({
    required this.totalEntrees,
    required this.totalDepenses,
    required this.annee,
  });
  final double totalEntrees;
  final double totalDepenses;
  final int    annee;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(locale: 'fr', symbol: '€');
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _KpiCard(
          montant:  fmt.format(totalEntrees),
          label:    'ENTRÉES',
          sousTitre: 'Cumul $annee',
          couleur:  AppColors.primary,
          icone:    Icons.trending_up_rounded,
        )),
        const SizedBox(width: 10),
        Expanded(child: _KpiCard(
          montant:  fmt.format(totalDepenses),
          label:    'DÉPENSES',
          sousTitre: 'Cumul $annee',
          couleur:  AppColors.secondary,
          icone:    Icons.trending_down_rounded,
        )),
      ]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.montant,
    required this.label,
    required this.sousTitre,
    required this.couleur,
    required this.icone,
  });
  final String   montant;
  final String   label;
  final String   sousTitre;
  final Color    couleur;
  final IconData icone;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: couleur,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(montant,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                    color: Colors.white)),
            Text(label,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: Colors.white70, letterSpacing: 0.8)),
            Text(sousTitre,
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
          Positioned(
            right: 0, bottom: 0,
            child: Icon(icone, color: Colors.white24, size: 32),
          ),
        ]),
      );
}

// ─── Solde Global ─────────────────────────────────────────────────────────────

class _BlocSolde extends StatelessWidget {
  const _BlocSolde({
    required this.solde,
    required this.totalEntrees,
    required this.totalDepenses,
    required this.fmt,
  });
  final double       solde;
  final double       totalEntrees;
  final double       totalDepenses;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SOLDE GLOBAL',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.text2, letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(
            fmt.format(solde),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: solde >= 0 ? AppColors.primary : AppColors.secondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Entrées ${fmt.format(totalEntrees)} · Dépenses ${fmt.format(totalDepenses)}',
            style: TextStyle(fontSize: 12, color: AppColors.text2),
          ),
        ]),
      );
}

// ─── Graphique 6 mois ─────────────────────────────────────────────────────────

class _GraphiqueEvolution extends StatelessWidget {
  const _GraphiqueEvolution({required this.evolution});
  final List<(DateTime, double, double)> evolution;

  static double _interval(double max) {
    if (max <= 100)    return 20;
    if (max <= 500)    return 100;
    if (max <= 2000)   return 500;
    if (max <= 10000)  return 2000;
    return 5000;
  }

  @override
  Widget build(BuildContext context) {
    if (evolution.isEmpty) return const SizedBox.shrink();
    final maxVal = evolution.fold(0.0,
        (m, e) => [m, e.$2, e.$3].reduce((a, b) => a > b ? a : b));
    final allZero = maxVal == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.fromLTRB(12, 14, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ENTRÉES VS DÉPENSES — 12 MOIS',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: allZero
              ? Center(child: Text('Aucune transaction sur cette période',
                  style: TextStyle(fontSize: 12, color: AppColors.text2)))
              : LineChart(LineChartData(
                  minY: 0,
                  maxY: maxVal * 1.15,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _interval(maxVal),
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: AppColors.border, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: _interval(maxVal),
                      getTitlesWidget: (v, _) => Text(
                        NumberFormat.compact(locale: 'fr').format(v),
                        style: TextStyle(fontSize: 9, color: AppColors.text2),
                      ),
                    )),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= evolution.length) return const SizedBox.shrink();
                        // n'affiche qu'un mois sur deux pour éviter l'overlap
                        if (i % 2 != 0) return const SizedBox.shrink();
                        return Text(
                          DateFormat('MMM', 'fr').format(evolution[i].$1),
                          style: TextStyle(fontSize: 9, color: AppColors.text2),
                        );
                      },
                    )),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    _ligne(evolution.asMap().entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.$2)).toList(),
                        AppColors.primary),
                    _ligne(evolution.asMap().entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.$3)).toList(),
                        AppColors.secondary),
                  ],
                )),
        ),
        const SizedBox(height: 8),
        Row(children: [
          _Legende(couleur: AppColors.primary,   label: 'Entrées'),
          const SizedBox(width: 14),
          _Legende(couleur: AppColors.secondary, label: 'Dépenses'),
        ]),
      ]),
    );
  }

  LineChartBarData _ligne(List<FlSpot> spots, Color couleur) =>
      LineChartBarData(
        spots:     spots,
        isCurved:  true,
        color:     couleur,
        barWidth:  2.5,
        dotData:   const FlDotData(show: true),
        belowBarData: BarAreaData(
            show: true, color: couleur.withValues(alpha: 0.08)),
      );
}

class _Legende extends StatelessWidget {
  const _Legende({required this.couleur, required this.label});
  final Color  couleur;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 12, height: 12,
            decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.15),
                border: Border.all(color: couleur),
                borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.text2)),
      ]);
}

// ─── Taux de recouvrement par sous-section ────────────────────────────────────

class _TauxParSS extends StatelessWidget {
  const _TauxParSS({required this.taux});
  // (nom, payees, total, taux%, code)
  final List<(String, int, int, double, String?)> taux;

  static const _palette = [
    AppColors.secondary,
    AppColors.accent,
    Color(0xFF1A4A8A),
    AppColors.primary,
    Color(0xFF5B2D8B),
    Color(0xFF0D7377),
  ];

  static String _badge(String? code) {
    if (code == null) return '?';
    final suffix = code.split('-').last;
    final n = int.tryParse(suffix);
    if (n != null) return n.toString();
    return suffix.length > 4 ? suffix.substring(0, 4) : suffix;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TAUX DE RECOUVREMENT PAR SOUS-SECTION',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 12),
        ...taux.take(AppConstants.maxLignesStats).toList().asMap().entries.map((e) {
          final (nom, payees, total, pct, code) = e.value;
          final couleur = _palette[e.key % _palette.length];
          final badge   = _badge(code);
          final enRetard = pct < AppConstants.objectifRecouvrement;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
                child: Center(child: Text(badge,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                        fontSize: badge.length > 3 ? 9 : 13),
                    textAlign: TextAlign.center)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(nom,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: AppColors.text),
                    overflow: TextOverflow.ellipsis),
                Text('$payees / $total',
                    style: TextStyle(fontSize: 10, color: AppColors.text2)),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Stack(children: [
                    Container(height: 6, color: AppColors.border),
                    FractionallySizedBox(
                      widthFactor: (pct / 100).clamp(0.0, 1.0),
                      child: Container(height: 6, color: couleur),
                    ),
                  ]),
                ),
              ])),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${pct.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                        color: enRetard ? AppColors.secondary : AppColors.primary)),
                if (enRetard)
                  Text('△ Bas',
                      style: TextStyle(fontSize: 9, color: AppColors.accent,
                          fontWeight: FontWeight.w700)),
              ]),
            ]),
          );
        }),
      ]),
    );
  }
}

// ─── Chips filtre ─────────────────────────────────────────────────────────────

class _FiltreChips extends StatelessWidget {
  const _FiltreChips({required this.filtreActif, required this.onChanged});
  final String filtreActif;
  final void Function(String) onChanged;

  static const _items = [
    (AppEnums.transactionEntree,  'Entrées',  Icons.arrow_downward_rounded),
    (AppEnums.transactionDepense, 'Dépenses', Icons.arrow_upward_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        children: _items.map((item) {
          final (valeur, label, icone) = item;
          final actif = filtreActif == valeur;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(icone, size: 13,
                  color: actif ? Colors.white : AppColors.text2),
              label: Text(label,
                  style: TextStyle(fontSize: 11,
                      color: actif ? Colors.white : AppColors.text2)),
              selected:        actif,
              onSelected:      (_) => onChanged(valeur),
              selectedColor:   AppColors.primary,
              backgroundColor: AppColors.card,
              side: BorderSide(color: actif ? AppColors.primary : AppColors.border),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Diagramme catégories en barres horizontales ─────────────────────────────

class _CategoriesBarChart extends StatelessWidget {
  const _CategoriesBarChart({required this.stats, required this.isEntree});
  final List<(String, double)> stats;
  final bool isEntree;

  static IconData _icon(String cat) => switch (cat) {
    AppCategories.cotisation     => Icons.account_balance_wallet_outlined,
    AppCategories.don            => Icons.volunteer_activism_outlined,
    AppCategories.beneficeEvent  => Icons.event_outlined,
    AppCategories.goodiesVente   => Icons.shopping_bag_outlined,
    AppCategories.logistique     => Icons.local_shipping_outlined,
    AppCategories.communication  => Icons.campaign_outlined,
    AppCategories.materiel       => Icons.inventory_2_outlined,
    AppCategories.deplacements   => Icons.commute_outlined,
    AppCategories.goodiesAchat   => Icons.shopping_cart_outlined,
    AppCategories.administration => Icons.description_outlined,
    AppCategories.formation      => Icons.school_outlined,
    _                            => Icons.attach_money_outlined,
  };

  static Color _couleur(String cat, bool isEntree) {
    if (isEntree) return AppColors.primary;
    return switch (cat) {
      AppCategories.logistique     => const Color(0xFFE64A19),
      AppCategories.communication  => const Color(0xFF1976D2),
      AppCategories.materiel       => const Color(0xFF455A64),
      AppCategories.deplacements   => const Color(0xFF00796B),
      AppCategories.goodiesAchat   => const Color(0xFF7B1FA2),
      AppCategories.administration => const Color(0xFF5D4037),
      AppCategories.formation      => const Color(0xFF303F9F),
      _                            => AppColors.secondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final fmt      = NumberFormat.currency(locale: 'fr', symbol: '€', decimalDigits: 0);
    final titre    = isEntree ? 'ENTRÉES PAR CATÉGORIE' : 'DÉPENSES PAR CATÉGORIE';
    final maxVal   = stats.isNotEmpty ? stats.first.$2 : 0.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titre,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 14),
        if (stats.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(isEntree ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                    size: 36, color: AppColors.border),
                const SizedBox(height: 10),
                Text(
                  isEntree
                      ? 'Aucune entrée enregistrée'
                      : 'Aucune dépense enregistrée',
                  style: TextStyle(fontSize: 13, color: AppColors.text2),
                ),
                const SizedBox(height: 4),
                Text('Appuyez sur "+ Ajouter" pour commencer',
                    style: TextStyle(fontSize: 11, color: AppColors.text2)),
              ]),
            ),
          ),
        ...stats.map((e) {
          final couleur = _couleur(e.$1, isEntree);
          final pct     = maxVal > 0 ? (e.$2 / maxVal).clamp(0.0, 1.0) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: couleur.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_icon(e.$1), size: 15, color: couleur),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(AppCategories.label(e.$1),
                    style: const TextStyle(fontSize: 13, color: AppColors.text),
                    overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Text(fmt.format(e.$2),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                        color: couleur)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: [
                  Container(height: 7, color: AppColors.border),
                  FractionallySizedBox(
                    widthFactor: pct,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: couleur,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          );
        }),
      ]),
    );
  }
}

// ─── Bouton Ajouter ───────────────────────────────────────────────────────────

class _BarreActions extends StatelessWidget {
  const _BarreActions({required this.onAjouter});
  final VoidCallback onAjouter;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: onAjouter,
            icon:  const Icon(Icons.add, size: 18),
            label: const Text('+ Ajouter une transaction',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
}

// ─── Comparatif financier par sous-section ────────────────────────────────────

class _ComparatifSS extends StatelessWidget {
  const _ComparatifSS({required this.items});
  // (nom, code, entrees, depenses)
  final List<(String, String?, double, double)> items;

  static const _palette = [
    AppColors.primary,
    Color(0xFF0D7377),
    Color(0xFF5B2D8B),
    AppColors.accent,
    Color(0xFF1976D2),
    AppColors.secondary,
  ];

  static String _badge(String? code) {
    if (code == null) return '?';
    final suffix = code.split('-').last;
    final n = int.tryParse(suffix);
    if (n != null) return n.toString();
    return suffix.length > 4 ? suffix.substring(0, 4) : suffix;
  }

  @override
  Widget build(BuildContext context) {
    final fmt    = NumberFormat.currency(locale: 'fr', symbol: '€', decimalDigits: 0);
    final maxVal = items.isEmpty
        ? 1.0
        : items.fold(0.0, (m, e) => [m, e.$3, e.$4].reduce((a, b) => a > b ? a : b));
    final toutVide = items.isNotEmpty && items.every((e) => e.$3 == 0 && e.$4 == 0);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('COMPARATIF PAR SOUS-SECTION',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 14),

        if (items.isEmpty)
          _etatVide('Aucune sous-section enregistrée')
        else ...[
          if (toutVide)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Aucune transaction enregistrée pour le moment',
                  style: TextStyle(fontSize: 11, color: AppColors.text2)),
            ),
          ...items.asMap().entries.map((e) {
            final (nom, code, entrees, depenses) = e.value;
            final solde   = entrees - depenses;
            final couleur = _palette[e.key % _palette.length];
            final badge   = _badge(code);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
                  child: Center(child: Text(badge,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                          fontSize: badge.length > 3 ? 9 : 13),
                      textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(nom,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                            color: AppColors.text),
                        overflow: TextOverflow.ellipsis)),
                    Text(
                      '${solde >= 0 ? '+' : ''}${fmt.format(solde)}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                          color: solde >= 0 ? AppColors.primary : AppColors.secondary),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _MiniBar(label: 'E', valeur: entrees, max: maxVal,
                      couleur: AppColors.primary, fmt: fmt),
                  const SizedBox(height: 4),
                  _MiniBar(label: 'D', valeur: depenses, max: maxVal,
                      couleur: AppColors.secondary, fmt: fmt),
                ])),
              ]),
            );
          }),
        ],
      ]),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({
    required this.label,
    required this.valeur,
    required this.max,
    required this.couleur,
    required this.fmt,
  });
  final String       label;
  final double       valeur;
  final double       max;
  final Color        couleur;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(label,
            style: TextStyle(fontSize: 9, color: AppColors.text2,
                fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(children: [
            Container(height: 6, color: AppColors.border),
            FractionallySizedBox(
              widthFactor: max > 0 ? (valeur / max).clamp(0.0, 1.0) : 0.0,
              child: Container(height: 6, color: couleur),
            ),
          ]),
        )),
        const SizedBox(width: 6),
        SizedBox(
          width: 56,
          child: Text(fmt.format(valeur),
              style: TextStyle(fontSize: 9, color: AppColors.text2),
              textAlign: TextAlign.right),
        ),
      ]);
}

// ─── Comparatif financier par cellule ────────────────────────────────────────

class _ComparatifCellules extends StatelessWidget {
  const _ComparatifCellules({required this.groupes});
  // (ssNom, ssCode, [(celNom, celCode, payees, total, taux%)])
  final List<(String, String?, List<(String, String?, int, int, double)>)> groupes;

  static String _badge(String? code) {
    if (code == null) return '?';
    final suffix = code.split('-').last;
    final n = int.tryParse(suffix);
    if (n != null) return n.toString();
    return suffix.length > 4 ? suffix.substring(0, 4) : suffix;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('TAUX DE RECOUVREMENT PAR CELLULE',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 14),

        if (groupes.isEmpty)
          _etatVide('Aucune cellule enregistrée')
        else
          ...groupes.expand((groupe) {
            final (ssNom, ssCode, cellules) = groupe;
            return [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 2),
                child: Row(children: [
                  Expanded(child: Divider(color: AppColors.border, height: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(ssNom,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: AppColors.text2)),
                  ),
                  Expanded(child: Divider(color: AppColors.border, height: 1)),
                ]),
              ),
              if (cellules.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('Aucune cellule dans cette sous-section',
                      style: TextStyle(fontSize: 11, color: AppColors.text2)),
                )
              else
                ...cellules.map((cel) {
                  final (nom, code, payees, total, taux) = cel;
                  final enRetard = taux < AppConstants.objectifRecouvrement;
                  final badge    = _badge(code);
                  final couleur  = enRetard ? AppColors.secondary : AppColors.primary;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
                        child: Center(child: Text(badge,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                                fontSize: badge.length > 3 ? 8 : 11),
                            textAlign: TextAlign.center)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(nom,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                color: AppColors.text),
                            overflow: TextOverflow.ellipsis),
                        Text('$payees / $total militants',
                            style: TextStyle(fontSize: 10, color: AppColors.text2)),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Stack(children: [
                            Container(height: 5, color: AppColors.border),
                            FractionallySizedBox(
                              widthFactor: (taux / 100).clamp(0.0, 1.0),
                              child: Container(height: 5, color: couleur),
                            ),
                          ]),
                        ),
                      ])),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${taux.toStringAsFixed(0)}%',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900,
                                color: couleur)),
                        if (enRetard)
                          Text('△ Bas',
                              style: TextStyle(fontSize: 9, color: AppColors.accent,
                                  fontWeight: FontWeight.w700)),
                      ]),
                    ]),
                  );
                }),
            ];
          }),
      ]),
    );
  }
}

Widget _etatVide(String message) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.bar_chart_outlined, size: 34, color: AppColors.border),
          const SizedBox(height: 8),
          Text(message,
              style: TextStyle(fontSize: 13, color: AppColors.text2),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Enregistrez des transactions pour voir les données',
              style: TextStyle(fontSize: 11, color: AppColors.text2),
              textAlign: TextAlign.center),
        ]),
      ),
    );

// ─── Utils ────────────────────────────────────────────────────────────────────

class _ErreurVue extends StatelessWidget {
  const _ErreurVue({required this.message, required this.onRetry});
  final String    message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, style: TextStyle(color: AppColors.secondary)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ]),
      );
}