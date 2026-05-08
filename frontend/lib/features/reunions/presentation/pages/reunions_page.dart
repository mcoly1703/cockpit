import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/reunion.dart';
import '../providers/reunions_provider.dart';
import 'reunion_detail_page.dart';
import 'reunion_form_page.dart';

class ReunionsPage extends ConsumerWidget {
  const ReunionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reunionsProvider);

    return state.when(
      initial:    () => const SizedBox.shrink(),
      chargement: () => const Center(child: CircularProgressIndicator()),
      erreur: (f) => _ErreurVue(
        message: f.when(
          serveur:     (m) => m,
          reseau:      () => 'Erreur réseau — vérifiez votre connexion',
          nonAutorise: () => 'Accès non autorisé',
          nonTrouve:   () => 'Données introuvables',
          validation:  (m) => m,
        ),
        onRetry: () => ref.read(reunionsProvider.notifier).charger(),
      ),
      charge: (_) => _ReunionsView(state: state),
    );
  }
}

// ─── Vue principale ───────────────────────────────────────────────────────────

class _ReunionsView extends ConsumerStatefulWidget {
  const _ReunionsView({required this.state});
  final ReunionsState state;

  @override
  ConsumerState<_ReunionsView> createState() => _ReunionsViewState();
}

class _ReunionsViewState extends ConsumerState<_ReunionsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.secondary : AppColors.primary,
    ));
  }

  Future<void> _ajouterReunion() async {
    final params = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => const ReunionFormPage()),
    );
    if (params == null || !mounted) return;
    final result = await ref.read(reunionsProvider.notifier).ajouterReunion(params);
    if (!mounted) return;
    result.fold(
      (f) => _snack('Erreur lors de la création', isError: true),
      (_) => _snack('Réunion créée'),
    );
  }

  void _ouvrirDetail(Reunion reunion) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReunionDetailPage(reunion: reunion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state  = widget.state;
    final aVenir = state.aVenir;
    final passes = state.passees;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouterReunion,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_outlined),
        label: const Text('Créer', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Titre + KPIs ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Réunions',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: AppColors.text)),
              Text('${aVenir.length} à venir · ${passes.length} passée${passes.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13, color: AppColors.text2)),
            ]),
          ),

          // ── Prochaine réunion ───────────────────────────────────────
          if (aVenir.isNotEmpty)
            _ProchaineReunion(reunion: aVenir.first, onTap: () => _ouvrirDetail(aVenir.first)),

          // ── Tabs ────────────────────────────────────────────────────
          Container(
            color: AppColors.card,
            child: TabBar(
              controller: _tabs,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(child: _TabLabel('À venir', aVenir.length, AppColors.primary)),
                Tab(child: _TabLabel('Passées',  passes.length,  AppColors.text2)),
              ],
            ),
          ),

          // ── Listes ──────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ListeReunions(
                  reunions: aVenir,
                  vide:     'Aucune réunion à venir',
                  onTap:    _ouvrirDetail,
                ),
                _ListeReunions(
                  reunions: passes,
                  vide:     'Aucune réunion passée',
                  onTap:    _ouvrirDetail,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Prochaine réunion (bandeau) ──────────────────────────────────────────────

class _ProchaineReunion extends StatelessWidget {
  const _ProchaineReunion({required this.reunion, required this.onTap});
  final Reunion      reunion;
  final VoidCallback onTap;

  String _labelType(String type) =>
      AppEnums.typesReunion.firstWhere((t) => t.$1 == type,
          orElse: () => (type, type)).$2;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEE dd MMM · HH:mm', 'fr');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.kpiVertGradient,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('PROCHAINE RÉUNION',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: Colors.white70, letterSpacing: 0.8)),
            const SizedBox(height: 4),
            Text(reunion.titre,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(fmt.format(reunion.date),
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text('${_labelType(reunion.type)} · ${reunion.lieu}',
                style: const TextStyle(fontSize: 11, color: Colors.white60)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
        ]),
      ),
    );
  }
}

// ─── Liste réunions ───────────────────────────────────────────────────────────

class _ListeReunions extends StatelessWidget {
  const _ListeReunions({
    required this.reunions,
    required this.vide,
    required this.onTap,
  });
  final List<Reunion>              reunions;
  final String                     vide;
  final void Function(Reunion) onTap;

  @override
  Widget build(BuildContext context) {
    if (reunions.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.groups_outlined, size: 48, color: AppColors.border),
          const SizedBox(height: 12),
          Text(vide, style: const TextStyle(fontSize: 14, color: AppColors.text2)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
      itemCount: reunions.length,
      itemBuilder: (_, i) => _ReunionCard(
        reunion: reunions[i],
        onTap:   () => onTap(reunions[i]),
      ),
    );
  }
}

class _ReunionCard extends StatelessWidget {
  const _ReunionCard({required this.reunion, required this.onTap});
  final Reunion      reunion;
  final VoidCallback onTap;

  String _labelType(String type) =>
      AppEnums.typesReunion.firstWhere((t) => t.$1 == type,
          orElse: () => (type, type)).$2;

  @override
  Widget build(BuildContext context) {
    final fmt    = DateFormat('dd MMM · HH:mm', 'fr');
    final aVenir = reunion.date.isAfter(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.cardShadow,
          border: aVenir
              ? const Border(left: BorderSide(color: AppColors.primary, width: 4))
              : null,
        ),
        child: Row(children: [
          // Date bloc
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: (aVenir ? AppColors.primary : AppColors.text2)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(DateFormat('dd', 'fr').format(reunion.date),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900,
                      color: aVenir ? AppColors.primary : AppColors.text2)),
              Text(DateFormat('MMM', 'fr').format(reunion.date).toUpperCase(),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: aVenir ? AppColors.primary : AppColors.text2)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(reunion.titre,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.text),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text('${fmt.format(reunion.date)} · ${reunion.lieu}',
                style: const TextStyle(fontSize: 11, color: AppColors.text2),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(_labelType(reunion.type),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: AppColors.accent)),
            ),
          ])),
          const Icon(Icons.chevron_right_rounded, color: AppColors.border, size: 20),
        ]),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel(this.label, this.count, this.couleur);
  final String label;
  final int    count;
  final Color  couleur;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: couleur)),
        ),
      ]);
}

// ─── Erreur ───────────────────────────────────────────────────────────────────

class _ErreurVue extends StatelessWidget {
  const _ErreurVue({required this.message, required this.onRetry});
  final String       message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, style: const TextStyle(color: AppColors.secondary)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ]),
      );
}