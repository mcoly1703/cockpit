import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/candidat_election.dart';
import '../../domain/entities/scrutin.dart';
import '../../domain/repositories/elections_repository.dart';
import '../providers/elections_provider.dart';

class ElectionDetailPage extends ConsumerWidget {
  const ElectionDetailPage({super.key, required this.scrutin});
  final Scrutin scrutin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidatsState = ref.watch(candidatsProvider(scrutin.id));
    final notifier       = ref.read(candidatsProvider(scrutin.id).notifier);
    final estClos        = scrutin.statut == AppEnums.scrutinClos;

    return Scaffold(
      appBar: AppBar(
        title: Text(scrutin.titre, overflow: TextOverflow.ellipsis),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) => _changerStatut(context, ref, val),
            itemBuilder: (_) => _autresStatuts(scrutin.statut)
                .map((s) => PopupMenuItem(value: s.$1, child: Text(s.$2)))
                .toList(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ─ En-tête info ─
          SliverToBoxAdapter(child: _EnteteScrutin(scrutin: scrutin)),

          // ─ Titre section candidats ─
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(children: [
                const Text('Candidats',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const Spacer(),
                if (!estClos)
                  TextButton.icon(
                    onPressed: () => _showFormCandidat(context, notifier),
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Ajouter'),
                  ),
              ]),
            ),
          ),

          // ─ Liste candidats ─
          candidatsState.when(
            initial:    () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            chargement: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator())),
            erreur: (f) => SliverToBoxAdapter(
              child: Center(child: Text(f.when(
                serveur: (m) => m, reseau: () => 'Erreur réseau',
                nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
                validation: (m) => m,
              ))),
            ),
            charge: (candidats) {
              if (candidats.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Aucun candidat enregistré',
                        style: TextStyle(color: Colors.black45))),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _CandidatCard(
                      candidat:  candidats[i],
                      estClos:   estClos,
                      notifier:  notifier,
                    ),
                    childCount: candidats.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _changerStatut(
      BuildContext context, WidgetRef ref, String newStatut) async {
    final result = await ref
        .read(electionsProvider.notifier)
        .changerStatut(scrutin.id, newStatut);
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(f.when(
          serveur: (m) => m, reseau: () => 'Erreur réseau',
          nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
          validation: (m) => m,
        )),
      )),
      (_) => Navigator.of(context).pop(),
    );
  }

  void _showFormCandidat(BuildContext context, CandidatsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormCandidat(
        scrutinId: scrutin.id,
        onSave: (params) async {
          Navigator.of(context).pop();
          await notifier.ajouterCandidat(params);
        },
      ),
    );
  }

  static List<(String, String)> _autresStatuts(String courant) {
    const tous = [
      (AppEnums.scrutinEnPreparation, 'En préparation'),
      (AppEnums.scrutinOuvert,        'Ouvrir le scrutin'),
      (AppEnums.scrutinClos,          'Clôturer le scrutin'),
    ];
    return tous.where((s) => s.$1 != courant).toList();
  }
}

// ─── En-tête scrutin ─────────────────────────────────────────────────────────

class _EnteteScrutin extends StatelessWidget {
  const _EnteteScrutin({required this.scrutin});
  final Scrutin scrutin;

  @override
  Widget build(BuildContext context) {
    final labelType = AppEnums.typesScrutin
        .firstWhere((t) => t.$1 == scrutin.type, orElse: () => (scrutin.type, scrutin.type))
        .$2;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Type + statut badges
        Row(children: [
          _Badge(labelType, AppColors.accent),
          const SizedBox(width: 8),
          _Badge(_labelStatut(scrutin.statut), _couleurStatut(scrutin.statut)),
        ]),
        const SizedBox(height: 12),
        // Date
        Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            DateFormat('EEEE dd MMMM yyyy', 'fr').format(scrutin.dateScrutin),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ]),
        // Description
        if (scrutin.description != null && scrutin.description!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(scrutin.description!,
              style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ]),
    );
  }

  static Color _couleurStatut(String statut) => switch (statut) {
        AppEnums.scrutinOuvert        => AppColors.primary,
        AppEnums.scrutinEnPreparation => AppColors.accent,
        _                             => Colors.grey,
      };

  static String _labelStatut(String statut) => switch (statut) {
        AppEnums.scrutinEnPreparation => 'En préparation',
        AppEnums.scrutinOuvert        => 'Ouvert',
        AppEnums.scrutinClos          => 'Clôturé',
        _                             => statut,
      };
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.couleur);
  final String label;
  final Color  couleur;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: couleur.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(color: couleur, fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

// ─── Carte candidat ───────────────────────────────────────────────────────────

class _CandidatCard extends StatelessWidget {
  const _CandidatCard({
    required this.candidat,
    required this.estClos,
    required this.notifier,
  });
  final CandidatElection candidat;
  final bool             estClos;
  final CandidatsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: candidat.elu
            ? const BorderSide(color: AppColors.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: candidat.elu
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.12),
          child: Text(
            _initiales(candidat),
            style: TextStyle(
              color: candidat.elu ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        title: Row(children: [
          Text(candidat.nomComplet,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          if (candidat.elu) ...[
            const SizedBox(width: 6),
            const Icon(Icons.verified, color: AppColors.primary, size: 16),
          ],
        ]),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (candidat.poste != null)
            Text(candidat.poste!,
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
          if (estClos && candidat.voix != null)
            Text('${candidat.voix} voix',
                style: const TextStyle(fontWeight: FontWeight.w600,
                    color: AppColors.accent, fontSize: 12)),
        ]),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (val) {
            if (val == 'resultat') {
              _showDialogResultat(context, notifier);
            } else if (val == 'retirer') {
              _confirmerRetrait(context, notifier);
            }
          },
          itemBuilder: (_) => [
            if (!estClos)
              const PopupMenuItem(value: 'retirer', child: Text('Retirer')),
            if (estClos)
              const PopupMenuItem(value: 'resultat', child: Text('Saisir résultat')),
          ],
        ),
      ),
    );
  }

  void _showDialogResultat(BuildContext context, CandidatsNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => _DialogResultat(
        candidat: candidat,
        onSave:   (params) async {
          Navigator.of(context).pop();
          await notifier.saisirResultat(params);
        },
      ),
    );
  }

  void _confirmerRetrait(BuildContext context, CandidatsNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Retirer le candidat ?'),
        content: Text('${candidat.nomComplet} sera retiré de ce scrutin.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            onPressed: () {
              Navigator.of(context).pop();
              notifier.retirerCandidat(candidat.id);
            },
            child: const Text('Retirer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static String _initiales(CandidatElection c) {
    final p = c.prenom.isNotEmpty ? c.prenom[0].toUpperCase() : '';
    final n = c.nom.isNotEmpty   ? c.nom[0].toUpperCase()    : '';
    return '$p$n';
  }
}

// ─── Formulaire candidat ──────────────────────────────────────────────────────

class _FormCandidat extends StatefulWidget {
  const _FormCandidat({required this.scrutinId, required this.onSave});
  final String   scrutinId;
  final Future<void> Function(ParamsAjouterCandidat) onSave;

  @override
  State<_FormCandidat> createState() => _FormCandidatState();
}

class _FormCandidatState extends State<_FormCandidat> {
  final _formKey   = GlobalKey<FormState>();
  final _nomCtrl   = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _posteCtrl = TextEditingController();
  bool _enEnvoi    = false;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _posteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enEnvoi = true);
    await widget.onSave(ParamsAjouterCandidat(
      scrutinId: widget.scrutinId,
      nom:       _nomCtrl.text.trim(),
      prenom:    _prenomCtrl.text.trim(),
      poste:     _posteCtrl.text.trim().isEmpty ? null : _posteCtrl.text.trim(),
    ));
    if (mounted) setState(() => _enEnvoi = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(
            child: Container(width: 36, height: 4,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 16),
          const Text('Ajouter un candidat',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: _prenomCtrl,
                decoration: const InputDecoration(labelText: 'Prénom *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom *', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          TextFormField(
            controller: _posteCtrl,
            decoration: const InputDecoration(
              labelText: 'Poste / liste (optionnel)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enEnvoi ? null : _submit,
              child: _enEnvoi
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Ajouter'),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Dialog résultat ──────────────────────────────────────────────────────────

class _DialogResultat extends StatefulWidget {
  const _DialogResultat({required this.candidat, required this.onSave});
  final CandidatElection candidat;
  final Future<void> Function(ParamsSaisirResultat) onSave;

  @override
  State<_DialogResultat> createState() => _DialogResultatState();
}

class _DialogResultatState extends State<_DialogResultat> {
  final _voixCtrl = TextEditingController();
  bool _elu = false;

  @override
  void initState() {
    super.initState();
    if (widget.candidat.voix != null) {
      _voixCtrl.text = '${widget.candidat.voix}';
    }
    _elu = widget.candidat.elu;
  }

  @override
  void dispose() {
    _voixCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Résultat — ${widget.candidat.nomComplet}'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _voixCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nombre de voix',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Candidat élu'),
          value: _elu,
          activeTrackColor:  AppColors.primary,
          activeThumbColor:  Colors.white,
          onChanged: (v) => setState(() => _elu = v),
          contentPadding: EdgeInsets.zero,
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            final voix = int.tryParse(_voixCtrl.text.trim());
            await widget.onSave(ParamsSaisirResultat(
              candidatId: widget.candidat.id,
              voix:       voix,
              elu:        _elu,
            ));
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}