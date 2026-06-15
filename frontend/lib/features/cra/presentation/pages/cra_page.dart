import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';
import '../providers/cra_provider.dart';
import 'cra_form_page.dart';

class CraPage extends ConsumerWidget {
  const CraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state       = ref.watch(craProvider);
    final notifier    = ref.read(craProvider.notifier);
    final estSuperviseur = notifier.estSuperviseur();

    return DefaultTabController(
      length: estSuperviseur ? 4 : 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comptes Rendus d\'Activité'),
          bottom: TabBar(
            isScrollable: true,
            labelColor:           Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor:       Colors.white,
            tabs: [
              const Tab(text: 'Brouillons'),
              const Tab(text: 'Soumis'),
              const Tab(text: 'Validés'),
              if (estSuperviseur) const Tab(text: 'À valider'),
            ],
          ),
        ),
        body: state.when(
          initial:    () => const SizedBox.shrink(),
          chargement: () => const Center(child: CircularProgressIndicator()),
          erreur:     (f) => _ErreurVue(
            failure:  f,
            onRetry:  () => ref.read(craProvider.notifier).charger(),
          ),
          charge: (_) => TabBarView(
            children: [
              _ListeCrs(crs: state.brouillons, vide: 'Aucun brouillon'),
              _ListeCrs(crs: state.soumis,     vide: 'Aucun CR soumis'),
              _ListeCrs(crs: state.valides,    vide: 'Aucun CR validé'),
              if (estSuperviseur) const _VueRecus(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _nouveauCr(context, ref),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Nouveau CR', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _nouveauCr(BuildContext context, WidgetRef ref) {
    final u = ref.read(craProvider.notifier);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CraFormPage(
          uniteId: _getUniteId(ref),
          onSave: (params) async {
            final result = await u.creerCr(params);
            return result;
          },
        ),
      ),
    );
  }

  String _getUniteId(WidgetRef ref) {
    // L'uniteId de l'utilisateur courant, géré dans le notifier
    // On lit directement depuis le state qui a déjà rechargé avec le bon uniteId
    return '';
  }
}

// ─── Liste de CRs ────────────────────────────────────────────────────────────

class _ListeCrs extends StatelessWidget {
  const _ListeCrs({required this.crs, required this.vide});
  final List<CompteRendu> crs;
  final String            vide;

  @override
  Widget build(BuildContext context) {
    if (crs.isEmpty) {
      return Center(
        child: Text(vide, style: const TextStyle(color: Colors.black45)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: crs.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _CrCard(cr: crs[i]),
    );
  }
}

// ─── Carte CR ─────────────────────────────────────────────────────────────────

class _CrCard extends ConsumerWidget {
  const _CrCard({required this.cr});
  final CompteRendu cr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couleur = _couleurStatut(cr.statut);
    final label   = _labelStatut(cr.statut);
    final periode = '${_nomMois(cr.mois)} ${cr.annee}';
    final estEditable = cr.statut == AppEnums.craBrouillon ||
        cr.statut == AppEnums.craRetourne;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: couleur.withValues(alpha: 0.35), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ─ En-tête ─
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(periode,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: couleur.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label,
                      style: TextStyle(color: couleur, fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (val) => _onAction(context, ref, val),
              itemBuilder: (_) => [
                if (estEditable)
                  const PopupMenuItem(value: 'editer', child: Text('Modifier')),
                if (estEditable)
                  const PopupMenuItem(value: 'soumettre', child: Text('Soumettre')),
                if (estEditable)
                  const PopupMenuItem(value: 'supprimer', child: Text('Supprimer')),
              ],
            ),
          ]),

          // ─ Retour coordinateur (si retourné) ─
          if (cr.statut == AppEnums.craRetourne &&
              cr.observationsCoord != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.undo_rounded, size: 14, color: AppColors.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(cr.observationsCoord!,
                      style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                ),
              ]),
            ),
          ],

          const SizedBox(height: 10),
          // ─ Métriques ─
          Row(children: [
            _Kpi(Icons.people_outline, '${cr.nouveauxContacts}', 'contacts'),
            const SizedBox(width: 12),
            _Kpi(Icons.event_outlined, '${cr.evenementsTenus}', 'événements'),
            const SizedBox(width: 12),
            _Kpi(Icons.how_to_reg_outlined, '${cr.presencesTotal}', 'présences'),
          ]),
        ]),
      ),
    );
  }

  Future<void> _onAction(BuildContext context, WidgetRef ref, String action) async {
    final notifier = ref.read(craProvider.notifier);
    switch (action) {
      case 'editer':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CraFormPage(
            uniteId: cr.uniteId,
            craExistant: cr,
            onSave: (params) async => notifier.mettreAJour(
              ParamsMajCr(
                id:                    cr.id,
                descriptionActivites:  params.descriptionActivites,
                nouveauxContacts:      params.nouveauxContacts,
                evenementsTenus:       params.evenementsTenus,
                presencesTotal:        params.presencesTotal,
                cotisationsCollectees: params.cotisationsCollectees,
                difficultes:           params.difficultes,
              ),
            ),
          ),
        ));
      case 'soumettre':
        final confirm = await _confirmer(context, 'Soumettre ce CR ?',
            'Il sera envoyé au coordinateur pour validation.');
        if (confirm && context.mounted) {
          final result = await notifier.soumettre(cr.id);
          result.fold(
            (f) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_msgFailure(f))),
            ),
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CR soumis avec succès')),
            ),
          );
        }
      case 'supprimer':
        final confirm = await _confirmer(context, 'Supprimer ce CR ?',
            'Cette action est irréversible.');
        if (confirm && context.mounted) {
          await notifier.supprimer(cr.id);
        }
    }
  }

  Future<bool> _confirmer(BuildContext context, String titre, String texte) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(titre),
            content: Text(texte),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler')),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirmer')),
            ],
          ),
        ) ??
        false;
  }

  static Color _couleurStatut(String s) => switch (s) {
        AppEnums.craBrouillon => Colors.grey,
        AppEnums.craSoumis    => AppColors.accent,
        AppEnums.craValide    => AppColors.primary,
        AppEnums.craRetourne  => AppColors.secondary,
        _                     => Colors.grey,
      };

  static String _labelStatut(String s) => switch (s) {
        AppEnums.craBrouillon => 'Brouillon',
        AppEnums.craSoumis    => 'Soumis',
        AppEnums.craValide    => 'Validé',
        AppEnums.craRetourne  => 'Retourné',
        _                     => s,
      };

  static String _msgFailure(Failure f) => f.when(
    serveur: (m) => m, reseau: () => 'Erreur réseau',
    nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
    validation: (m) => m,
  );
}

class _Kpi extends StatelessWidget {
  const _Kpi(this.icone, this.valeur, this.label);
  final IconData icone;
  final String   valeur;
  final String   label;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icone, size: 14, color: Colors.black45),
        const SizedBox(width: 4),
        Text('$valeur $label',
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]);
}

// ─── Vue CR reçus (superviseur) ──────────────────────────────────────────────

class _VueRecus extends ConsumerWidget {
  const _VueRecus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(craRecusProvider);

    return state.when(
      initial:    () => const SizedBox.shrink(),
      chargement: () => const Center(child: CircularProgressIndicator()),
      erreur:     (f) => Center(child: Text(_msgFailure(f))),
      charge: (rendus) {
        if (rendus.isEmpty) {
          return const Center(
            child: Text('Aucun CR en attente de validation',
                style: TextStyle(color: Colors.black45)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: rendus.length,
          separatorBuilder: (_, i) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) => _CrRecuCard(cr: rendus[i]),
        );
      },
    );
  }

  static String _msgFailure(Failure f) => f.when(
    serveur: (m) => m, reseau: () => 'Erreur réseau',
    nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
    validation: (m) => m,
  );
}

class _CrRecuCard extends ConsumerWidget {
  const _CrRecuCard({required this.cr});
  final CompteRendu cr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(craRecusProvider.notifier);
    final periode  = '${_nomMois(cr.mois)} ${cr.annee}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.accent.withValues(alpha: 0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (cr.uniteCode != null)
                  Text(cr.uniteCode!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary, fontSize: 13)),
                Text(periode,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ]),
            ),
            if (cr.soumisAt != null)
              Text(
                'soumis ${DateFormat('dd/MM', 'fr').format(cr.soumisAt!)}',
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
          ]),
          const SizedBox(height: 8),
          Text(cr.descriptionActivites,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 10),
          Row(children: [
            _Kpi(Icons.people_outline, '${cr.nouveauxContacts}', 'contacts'),
            const SizedBox(width: 12),
            _Kpi(Icons.event_outlined, '${cr.evenementsTenus}', 'événements'),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showRetour(context, notifier),
                icon: const Icon(Icons.undo_rounded, size: 16),
                label: const Text('Retourner'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.secondary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await notifier.valider(cr.id);
                  result.fold(
                    (f) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(f.when(
                        serveur: (m) => m, reseau: () => 'Erreur réseau',
                        nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
                        validation: (m) => m,
                      ))),
                    ),
                    (_) {},
                  );
                },
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: const Text('Valider'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  void _showRetour(BuildContext context, CraRecusNotifier notifier) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Retourner avec observations'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Indiquer ce qui doit être corrigé…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final obs = ctrl.text.trim();
              if (obs.isEmpty) return;
              Navigator.of(context).pop();
              await notifier.retourner(cr.id, obs);
            },
            child: const Text('Retourner'),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _ErreurVue extends StatelessWidget {
  const _ErreurVue({required this.failure, required this.onRetry});
  final Failure      failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.secondary),
          const SizedBox(height: 8),
          Text(failure.when(
            serveur: (m) => m, reseau: () => 'Erreur réseau',
            nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
            validation: (m) => m,
          )),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ]),
      );
}

const _moisNoms = [
  '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
  'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
];

String _nomMois(int m) => m >= 1 && m <= 12 ? _moisNoms[m] : '$m';