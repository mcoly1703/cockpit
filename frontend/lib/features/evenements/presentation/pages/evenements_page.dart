import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/evenement.dart';
import '../providers/evenements_provider.dart';
import 'evenement_detail_page.dart';
import 'evenement_form_page.dart';

class EvenementsPage extends ConsumerWidget {
  const EvenementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evenementsProvider);

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
        onRetry: () => ref.read(evenementsProvider.notifier).charger(),
      ),
      charge: (_) => _EvenementsView(state: state),
    );
  }
}

// ─── Vue principale ───────────────────────────────────────────────────────────

class _EvenementsView extends ConsumerStatefulWidget {
  const _EvenementsView({required this.state});
  final EvenementsState state;

  @override
  ConsumerState<_EvenementsView> createState() => _EvenementsViewState();
}

class _EvenementsViewState extends ConsumerState<_EvenementsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
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

  Future<void> _ajouterEvenement() async {
    final params = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => const EvenementFormPage()),
    );
    if (params == null || !mounted) return;
    final result = await ref.read(evenementsProvider.notifier).ajouterEvenement(params);
    if (!mounted) return;
    result.fold(
      (f) => _snack('Erreur lors de la création', isError: true),
      (_) => _snack('Événement créé'),
    );
  }

  void _ouvrirDetail(Evenement evenement) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EvenementDetailPage(evenement: evenement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state    = widget.state;
    final tous     = state.tous;
    final aVenir   = state.aVenir;
    final termines = state.termines;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouterEvenement,
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
              const Text('Événements',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: AppColors.text)),
              Text('${aVenir.length} à venir · ${termines.length} terminé${termines.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13, color: AppColors.text2)),
            ]),
          ),

          // ── Prochain événement ──────────────────────────────────────
          if (aVenir.isNotEmpty)
            _ProchainEvenement(evenement: aVenir.first, onTap: () => _ouvrirDetail(aVenir.first)),

          // ── Tabs ────────────────────────────────────────────────────
          Container(
            color: AppColors.card,
            child: TabBar(
              controller: _tabs,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(child: _TabLabel('Tous',      tous.length,     AppColors.text2)),
                Tab(child: _TabLabel('À venir',   aVenir.length,   AppColors.primary)),
                Tab(child: _TabLabel('Terminés',  termines.length, AppColors.text2)),
              ],
            ),
          ),

          // ── Listes ──────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ListeEvenements(
                  evenements: tous,
                  vide: 'Aucun événement',
                  onTap: _ouvrirDetail,
                ),
                _ListeEvenements(
                  evenements: aVenir,
                  vide: 'Aucun événement à venir',
                  onTap: _ouvrirDetail,
                ),
                _ListeEvenements(
                  evenements: termines,
                  vide: 'Aucun événement terminé',
                  onTap: _ouvrirDetail,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Prochain événement (bandeau) ─────────────────────────────────────────────

class _ProchainEvenement extends StatelessWidget {
  const _ProchainEvenement({required this.evenement, required this.onTap});
  final Evenement    evenement;
  final VoidCallback onTap;

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
            Text('PROCHAIN ÉVÉNEMENT',
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: Colors.white70, letterSpacing: 0.8)),
            const SizedBox(height: 4),
            Text(evenement.titre,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(fmt.format(evenement.dateDebut),
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text(evenement.lieu,
                style: const TextStyle(fontSize: 11, color: Colors.white60)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 24),
        ]),
      ),
    );
  }
}

// ─── Liste événements ─────────────────────────────────────────────────────────

class _ListeEvenements extends StatelessWidget {
  const _ListeEvenements({
    required this.evenements,
    required this.vide,
    required this.onTap,
  });
  final List<Evenement>              evenements;
  final String                       vide;
  final void Function(Evenement) onTap;

  @override
  Widget build(BuildContext context) {
    if (evenements.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.event_outlined, size: 48, color: AppColors.border),
          const SizedBox(height: 12),
          Text(vide, style: const TextStyle(fontSize: 14, color: AppColors.text2)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
      itemCount: evenements.length,
      itemBuilder: (_, i) => _EvenementCard(
        evenement: evenements[i],
        onTap: () => onTap(evenements[i]),
      ),
    );
  }
}

class _EvenementCard extends StatelessWidget {
  const _EvenementCard({required this.evenement, required this.onTap});
  final Evenement    evenement;
  final VoidCallback onTap;

  String _labelType(String type) =>
      AppEnums.typesEvenement.firstWhere((t) => t.$1 == type,
          orElse: () => (type, type)).$2;

  @override
  Widget build(BuildContext context) {
    final fmt    = DateFormat('dd MMM · HH:mm', 'fr');
    final aVenir = evenement.dateDebut.isAfter(DateTime.now());

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
              ? Border(left: BorderSide(color: AppColors.primary, width: 4))
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
              Text(DateFormat('dd', 'fr').format(evenement.dateDebut),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900,
                      color: aVenir ? AppColors.primary : AppColors.text2)),
              Text(DateFormat('MMM', 'fr').format(evenement.dateDebut).toUpperCase(),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: aVenir ? AppColors.primary : AppColors.text2)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(evenement.titre,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.text),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text('${fmt.format(evenement.dateDebut)} · ${evenement.lieu}',
                style: TextStyle(fontSize: 11, color: AppColors.text2),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(_labelType(evenement.type),
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