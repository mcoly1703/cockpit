import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/poste_bureau.dart';
import '../../domain/repositories/bureau_repository.dart';
import '../providers/bureau_provider.dart';

class BureauPage extends ConsumerWidget {
  const BureauPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bureauProvider);

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
        onRetry: () => ref.read(bureauProvider.notifier).charger(),
      ),
      charge: (_) => _BureauView(state: state),
    );
  }
}

// ─── Vue principale ───────────────────────────────────────────────────────────

class _BureauView extends ConsumerWidget {
  const _BureauView({required this.state});
  final BureauState state;

  void _snack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.secondary : AppColors.primary,
    ));
  }

  Future<void> _nommer(BuildContext context, WidgetRef ref, String intitule) async {
    final utilisateur = ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) return;

    final params = await showDialog<ParamsNommerMembre>(
      context: context,
      builder: (_) => _DialogNomination(
        uniteId:  utilisateur.uniteOrganisationnelleId ?? '',
        intitule: intitule,
      ),
    );
    if (params == null || !context.mounted) return;

    final result = await ref.read(bureauProvider.notifier).nommerMembre(params);
    if (!context.mounted) return;
    result.fold(
      (f) => _snack(context, 'Erreur lors de la nomination', isError: true),
      (_) => _snack(context, 'Membre nommé'),
    );
  }

  Future<void> _retirer(BuildContext context, WidgetRef ref, PosteBureau poste) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Retirer ce membre ?'),
        content: Text(
            '${poste.militantPrenom} ${poste.militantNom} sera retiré du poste de '
            '"${_labelPoste(poste.intitule, ref)}"'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white),
              child: const Text('Retirer')),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;

    final result = await ref.read(bureauProvider.notifier).retirerMembre(poste.id);
    if (!context.mounted) return;
    result.fold(
      (f) => _snack(context, 'Erreur', isError: true),
      (_) => _snack(context, 'Membre retiré'),
    );
  }

  String _labelPoste(String intitule, WidgetRef ref) {
    final liste = ref.read(bureauProvider.notifier).getListePostes();
    return liste.firstWhere((t) => t.$1 == intitule,
        orElse: () => (intitule, intitule)).$2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier    = ref.read(bureauProvider.notifier);
    final listePostes = notifier.getListePostes();
    final totalPostes  = listePostes.length;
    final totalPourvus = state.totalPourvus;

    // Mandat calculé à partir de la plus ancienne date de nomination
    final postes = state.maybeWhen(charge: (p) => p, orElse: () => <PosteBureau>[]);
    final debutMandat = postes.isEmpty
        ? null
        : postes.map((p) => p.dateNomination).reduce((a, b) => a.isBefore(b) ? a : b);
    final mandatLabel = debutMandat != null
        ? 'Mandat ${debutMandat.year}–${debutMandat.year + 6}'
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(children: [
              // ── En-tête ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Bureau',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                          color: AppColors.text)),
                  const SizedBox(height: 2),
                  Row(children: [
                    Text('Composition et mandats',
                        style: const TextStyle(fontSize: 13, color: AppColors.text2)),
                    if (mandatLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          mandatLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ]),
                ]),
              ),

              // ── KPI ──────────────────────────────────────────────────
              _KpiBureau(pourvus: totalPourvus, total: totalPostes),
            ]),
          ),

          // ── Liste des postes ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final (intitule, label) = listePostes[i];
                  final poste = state.posteParIntitule(intitule);
                  return _PosteCard(
                    intitule:  intitule,
                    label:     label,
                    poste:     poste,
                    onNommer:  () => _nommer(context, ref, intitule),
                    onRetirer: poste != null
                        ? () => _retirer(context, ref, poste)
                        : null,
                  );
                },
                childCount: listePostes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── KPI bureau ───────────────────────────────────────────────────────────────

class _KpiBureau extends StatelessWidget {
  const _KpiBureau({required this.pourvus, required this.total});
  final int pourvus;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? pourvus / total : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.kpiVertGradient,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('POSTES POURVUS',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: Colors.white70, letterSpacing: 0.8)),
          Text('$pourvus / $total',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900,
                  color: Colors.white)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text('${(pct * 100).round()}% du bureau constitué',
              style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ])),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.groups_outlined, color: Colors.white, size: 32),
        ),
      ]),
    );
  }
}

// ─── Carte poste ──────────────────────────────────────────────────────────────

class _PosteCard extends StatelessWidget {
  const _PosteCard({
    required this.intitule,
    required this.label,
    required this.poste,
    required this.onNommer,
    required this.onRetirer,
  });
  final String        intitule;
  final String        label;
  final PosteBureau?  poste;
  final VoidCallback  onNommer;
  final VoidCallback? onRetirer;

  @override
  Widget build(BuildContext context) {
    final estPourvu = poste != null;
    final fmt = DateFormat('dd/MM/yyyy', 'fr');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
        border: estPourvu
            ? const Border(left: BorderSide(color: AppColors.primary, width: 4))
            : Border(left: BorderSide(color: AppColors.border, width: 4)),
      ),
      child: Row(children: [
        // Avatar / initiales
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: estPourvu
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.border.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: estPourvu
                ? Text(
                    '${poste!.militantPrenom.isNotEmpty ? poste!.militantPrenom[0] : ''}'
                    '${poste!.militantNom.isNotEmpty ? poste!.militantNom[0] : ''}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  )
                : const Icon(Icons.person_outline, size: 20, color: AppColors.text2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 2),
          if (estPourvu) ...[
            Text('${poste!.militantPrenom} ${poste!.militantNom}',
                style: const TextStyle(fontSize: 12, color: AppColors.text2)),
            Text('Depuis le ${fmt.format(poste!.dateNomination)}',
                style: const TextStyle(fontSize: 10, color: AppColors.text2)),
          ] else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('VACANT',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: AppColors.secondary)),
            ),
        ])),
        // Actions
        if (estPourvu)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.text2),
            onSelected: (v) {
              if (v == 'remplacer') onNommer();
              if (v == 'retirer') onRetirer?.call();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'remplacer', child: Text('Remplacer')),
              PopupMenuItem(value: 'retirer',   child: Text('Retirer')),
            ],
          )
        else
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.primary, size: 22),
            onPressed: onNommer,
            tooltip: 'Nommer un membre',
          ),
      ]),
    );
  }
}

// ─── Dialog nomination ────────────────────────────────────────────────────────

class _DialogNomination extends ConsumerStatefulWidget {
  const _DialogNomination({required this.uniteId, required this.intitule});
  final String uniteId;
  final String intitule;

  @override
  ConsumerState<_DialogNomination> createState() => _DialogNominationState();
}

class _DialogNominationState extends ConsumerState<_DialogNomination> {
  final _searchCtrl = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  MilitantResume? _militant;
  List<MilitantResume> _resultats = [];
  bool _chargement = false;
  DateTime _dateNomination = DateTime.now();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _chercher(String query) async {
    if (query.length < 2) {
      setState(() => _resultats = []);
      return;
    }
    setState(() => _chargement = true);
    final result = await ref.read(bureauProvider.notifier).searchMilitants(query);
    if (!mounted) return;
    result.fold(
      (_) => setState(() { _resultats = []; _chargement = false; }),
      (r) => setState(() { _resultats = r; _chargement = false; }),
    );
  }

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateNomination,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null && mounted) setState(() => _dateNomination = d);
  }

  String _labelPoste() {
    final liste = ref.read(bureauProvider.notifier).getListePostes();
    return liste.firstWhere((t) => t.$1 == widget.intitule,
        orElse: () => (widget.intitule, widget.intitule)).$2;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy', 'fr');
    return AlertDialog(
      title: Text('Nommer — ${_labelPoste()}'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // ── Recherche militant ────────────────────────────────────
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Rechercher un militant',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _chargement
                    ? const SizedBox(width: 16, height: 16,
                        child: Padding(padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(strokeWidth: 2)))
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _chercher,
            ),
            const SizedBox(height: 8),

            // ── Résultats ─────────────────────────────────────────────
            if (_resultats.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _resultats.length,
                  itemBuilder: (_, i) {
                    final m = _resultats[i];
                    final selectionne = _militant?.id == m.id;
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: selectionne
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          '${m.prenom.isNotEmpty ? m.prenom[0] : ''}${m.nom.isNotEmpty ? m.nom[0] : ''}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                              color: selectionne ? Colors.white : AppColors.primary),
                        ),
                      ),
                      title: Text(m.nomComplet,
                          style: const TextStyle(fontSize: 13)),
                      selected: selectionne,
                      selectedTileColor: AppColors.primary.withValues(alpha: 0.06),
                      onTap: () => setState(() {
                        _militant = m;
                        _searchCtrl.text = m.nomComplet;
                        _resultats = [];
                      }),
                    );
                  },
                ),
              ),

            if (_militant != null) ...[
              const SizedBox(height: 12),
              // ── Militant sélectionné ──────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(_militant!.nomComplet,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w600, color: AppColors.primary)),
                ]),
              ),
              const SizedBox(height: 8),
              // ── Date de nomination ────────────────────────────────
              InkWell(
                onTap: _choisirDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date de nomination'),
                  child: Text(fmt.format(_dateNomination),
                      style: const TextStyle(fontSize: 14, color: AppColors.text)),
                ),
              ),
            ],
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _militant == null
              ? null
              : () => Navigator.of(context).pop(
                    ParamsNommerMembre(
                      uniteId:        widget.uniteId,
                      intitule:       widget.intitule,
                      militantId:     _militant!.id,
                      dateNomination: _dateNomination,
                    ),
                  ),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Nommer'),
        ),
      ],
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