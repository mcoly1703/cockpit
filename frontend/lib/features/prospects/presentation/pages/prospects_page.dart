import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../militants/presentation/providers/militants_provider.dart';
import '../../domain/entities/prospect.dart';
import '../providers/prospects_provider.dart';
import 'prospect_form_page.dart';

// Libellés et couleurs par étape
const _etapesMeta = {
  AppEnums.etapeContact:      ('Contact',      AppColors.primary,   Icons.person_add_outlined),
  AppEnums.etapeSympathisant: ('Sympathisant', AppColors.accent,    Icons.favorite_border_outlined),
  AppEnums.etapeAdherent:     ('Adhérent',     Color(0xFF0D7377),   Icons.how_to_reg_outlined),
  AppEnums.etapeConverti:     ('Converti',     Color(0xFF388E3C),   Icons.emoji_events_outlined),
};

class ProspectsPage extends ConsumerWidget {
  const ProspectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prospectsProvider);

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
        onRetry: () => ref.read(prospectsProvider.notifier).charger(),
      ),
      charge: (_) => _EntonniorView(state: state),
    );
  }
}

// ─── Vue entonnoir ────────────────────────────────────────────────────────────

class _EntonniorView extends ConsumerStatefulWidget {
  const _EntonniorView({required this.state});
  final ProspectsState state;

  @override
  ConsumerState<_EntonniorView> createState() => _EntonniorViewState();
}

class _EntonniorViewState extends ConsumerState<_EntonniorView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: AppEnums.etapesProspect.length, vsync: this);
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

  static const _mouvementsNoms = ['JPS', 'MOJIP', 'Cadres', 'Foyers', 'Maggi Pastef'];

  String? _detecterMouvement() {
    final utilisateur = ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null || utilisateur.role != AppRoles.responsableMouvement) return null;
    final uniteId = utilisateur.uniteOrganisationnelleId;
    if (uniteId == null) return null;
    final unites = ref.read(militantsProvider).maybeWhen(
        charge: (_, u, __, ___) => u, orElse: () => []);
    final monUnite = unites.where((u) => u.id == uniteId).firstOrNull;
    if (monUnite == null) return null;
    final lower = monUnite.nom.toLowerCase();
    for (final m in _mouvementsNoms) {
      if (lower.contains(m.toLowerCase())) return m;
    }
    return null;
  }

  Future<void> _ajouterProspect() async {
    final params = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(builder: (_) => ProspectFormPage(
        mouvementPreselectionne: _detecterMouvement(),
      )),
    );
    if (params == null || !mounted) return;
    final result = await ref.read(prospectsProvider.notifier).ajouterProspect(params);
    if (!mounted) return;
    result.fold(
      (f) => _snack('Erreur lors de l\'enregistrement', isError: true),
      (_) => _snack('Prospect ajouté'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouterProspect,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Ajouter', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Titre + stats globales ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Prospects',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.text)),
              Text('${state.total} au total · ${state.tauxConversion.toStringAsFixed(0)}% convertis',
                  style: const TextStyle(fontSize: 13, color: AppColors.text2)),
            ]),
          ),

          // ── Bandeau entonnoir ───────────────────────────────────────
          _BandeauEntonnoir(state: state),

          // ── Tabs ────────────────────────────────────────────────────
          Container(
            color: AppColors.card,
            child: TabBar(
              controller: _tabs,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              indicatorColor: AppColors.primary,
              tabs: AppEnums.etapesProspect.map((e) {
                final meta  = _etapesMeta[e]!;
                final count = state.countParEtape(e);
                return Tab(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(meta.$1),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: meta.$2.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('$count',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                              color: meta.$2)),
                    ),
                  ]),
                );
              }).toList(),
            ),
          ),

          // ── Listes par étape ────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: AppEnums.etapesProspect.map((etape) {
                final prospects = state.parEtape(etape);
                if (prospects.isEmpty) return _EtapeVide(etape: etape);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                  itemCount: prospects.length,
                  itemBuilder: (_, i) => _ProspectCard(
                    prospect: prospects[i],
                    onAvancer:  _peutAvancer(etape)
                        ? () => _avancerEtape(prospects[i], etape)
                        : null,
                    onRegresser: _peutRegresser(etape)
                        ? () => _regresserEtape(prospects[i], etape)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _peutAvancer(String etape)   => etape != AppEnums.etapeConverti;
  bool _peutRegresser(String etape) => etape != AppEnums.etapeContact;

  String _etapeSuivante(String etape) {
    final idx = AppEnums.etapesProspect.indexOf(etape);
    return AppEnums.etapesProspect[idx + 1];
  }

  String _etapePrecedente(String etape) {
    final idx = AppEnums.etapesProspect.indexOf(etape);
    return AppEnums.etapesProspect[idx - 1];
  }

  Future<void> _avancerEtape(Prospect p, String etapeActuelle) async {
    final next = _etapeSuivante(etapeActuelle);
    final result = await ref.read(prospectsProvider.notifier).modifierEtape(p.id, next);
    if (!mounted) return;
    result.fold(
      (f) => _snack('Erreur', isError: true),
      (_) => _snack('${p.prenom} ${p.nom} → ${_etapesMeta[next]!.$1}'),
    );
  }

  Future<void> _regresserEtape(Prospect p, String etapeActuelle) async {
    final prev = _etapePrecedente(etapeActuelle);
    final result = await ref.read(prospectsProvider.notifier).modifierEtape(p.id, prev);
    if (!mounted) return;
    result.fold(
      (f) => _snack('Erreur', isError: true),
      (_) {},
    );
  }
}

// ─── Bandeau entonnoir ────────────────────────────────────────────────────────

class _BandeauEntonnoir extends StatelessWidget {
  const _BandeauEntonnoir({required this.state});
  final ProspectsState state;

  @override
  Widget build(BuildContext context) {
    final total = state.total;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: AppEnums.etapesProspect.asMap().entries.map((e) {
          final etape = e.value;
          final meta  = _etapesMeta[etape]!;
          final count = state.countParEtape(etape);
          final pct   = total > 0 ? count / total : 0.0;
          final isLast = e.key == AppEnums.etapesProspect.length - 1;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Icon(meta.$3, color: meta.$2, size: 20),
                    const SizedBox(height: 4),
                    Text('$count',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900,
                            color: meta.$2)),
                    Text(meta.$1,
                        style: const TextStyle(fontSize: 9, color: AppColors.text2),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('${(pct * 100).toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                            color: meta.$2)),
                  ]),
                ),
                if (!isLast)
                  const Icon(Icons.chevron_right_rounded, color: AppColors.border, size: 18),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Card prospect ────────────────────────────────────────────────────────────

class _ProspectCard extends StatelessWidget {
  const _ProspectCard({
    required this.prospect,
    required this.onAvancer,
    required this.onRegresser,
  });
  final Prospect     prospect;
  final VoidCallback? onAvancer;
  final VoidCallback? onRegresser;

  String get _initiales =>
      '${prospect.prenom.isNotEmpty ? prospect.prenom[0] : ''}${prospect.nom.isNotEmpty ? prospect.nom[0] : ''}'
          .toUpperCase();

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy', 'fr');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(children: [
        // Avatar
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(_initiales,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
                    fontSize: 14)),
          ),
        ),
        const SizedBox(width: 12),
        // Infos
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${prospect.prenom} ${prospect.nom}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 2),
          Text(prospect.telephone,
              style: const TextStyle(fontSize: 12, color: AppColors.text2)),
          if (prospect.ville.isNotEmpty)
            Text(prospect.ville,
                style: const TextStyle(fontSize: 11, color: AppColors.text2)),
          if (prospect.mouvementInteret != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(prospect.mouvementInteret!,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: AppColors.accent)),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            [
              'Contact le ${fmt.format(prospect.dateContact)}',
              if (prospect.createdByNom != null) 'par ${prospect.createdByNom}',
            ].join(' · '),
            style: const TextStyle(fontSize: 10, color: AppColors.text2),
          ),
        ])),
        // Actions
        Column(mainAxisSize: MainAxisSize.min, children: [
          if (onAvancer != null)
            _BoutonAction(
              icone: Icons.arrow_forward_ios_rounded,
              couleur: AppColors.primary,
              onTap: onAvancer!,
              tooltip: 'Avancer',
            ),
          if (onRegresser != null) ...[
            const SizedBox(height: 4),
            _BoutonAction(
              icone: Icons.arrow_back_ios_rounded,
              couleur: AppColors.text2,
              onTap: onRegresser!,
              tooltip: 'Régresser',
            ),
          ],
        ]),
      ]),
    );
  }
}

class _BoutonAction extends StatelessWidget {
  const _BoutonAction({
    required this.icone,
    required this.couleur,
    required this.onTap,
    required this.tooltip,
  });
  final IconData     icone;
  final Color        couleur;
  final VoidCallback onTap;
  final String       tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, size: 14, color: couleur),
          ),
        ),
      );
}

// ─── Étape vide ───────────────────────────────────────────────────────────────

class _EtapeVide extends StatelessWidget {
  const _EtapeVide({required this.etape});
  final String etape;

  @override
  Widget build(BuildContext context) {
    final meta = _etapesMeta[etape]!;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(meta.$3, size: 48, color: AppColors.border),
        const SizedBox(height: 12),
        Text('Aucun prospect en étape "${meta.$1}"',
            style: const TextStyle(fontSize: 14, color: AppColors.text2)),
        const SizedBox(height: 4),
        const Text('Appuyez sur "+ Ajouter" pour commencer',
            style: TextStyle(fontSize: 12, color: AppColors.text2)),
      ]),
    );
  }
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