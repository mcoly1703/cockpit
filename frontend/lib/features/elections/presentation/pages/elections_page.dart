import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/scrutin.dart';
import '../../domain/repositories/elections_repository.dart';
import '../providers/elections_provider.dart';
import 'election_detail_page.dart';

class ElectionsPage extends ConsumerWidget {
  const ElectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(electionsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Élections & Scrutins'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'À venir'),
              Tab(text: 'Terminés'),
            ],
          ),
        ),
        body: state.when(
          initial:     () => const SizedBox.shrink(),
          chargement:  () => const Center(child: CircularProgressIndicator()),
          erreur:      (f) => _ErreurVue(failure: f, onRetry: () => ref.read(electionsProvider.notifier).charger()),
          charge:      (_) => _TabsContent(state: state),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showFormScrutin(context, ref),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Nouveau scrutin', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _showFormScrutin(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormScrutin(
        onSave: (params) async {
          Navigator.of(context).pop();
          final err = await ref.read(electionsProvider.notifier).ajouterScrutin(params);
          err.fold(
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
      ),
    );
  }
}

// ─── Contenu onglets ─────────────────────────────────────────────────────────

class _TabsContent extends StatelessWidget {
  const _TabsContent({required this.state});
  final ElectionsState state;

  @override
  Widget build(BuildContext context) {
    final aVenir = state.aVenir;
    final passes = state.passes;

    return TabBarView(
      children: [
        _ListeScrutins(scrutins: aVenir, vide: 'Aucun scrutin à venir'),
        _ListeScrutins(scrutins: passes, vide: 'Aucun scrutin terminé'),
      ],
    );
  }
}

class _ListeScrutins extends StatelessWidget {
  const _ListeScrutins({required this.scrutins, required this.vide});
  final List<Scrutin> scrutins;
  final String vide;

  @override
  Widget build(BuildContext context) {
    if (scrutins.isEmpty) {
      return Center(
        child: Text(vide, style: const TextStyle(color: Colors.black45)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: scrutins.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _ScrutinCard(scrutin: scrutins[i]),
    );
  }
}

// ─── Carte scrutin ────────────────────────────────────────────────────────────

class _ScrutinCard extends StatelessWidget {
  const _ScrutinCard({required this.scrutin});
  final Scrutin scrutin;

  @override
  Widget build(BuildContext context) {
    final couleurStatut = _couleurStatut(scrutin.statut);
    final labelType     = AppEnums.typesScrutin
        .firstWhere((t) => t.$1 == scrutin.type, orElse: () => (scrutin.type, scrutin.type))
        .$2;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: couleurStatut.withValues(alpha: 0.4), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ElectionDetailPage(scrutin: scrutin)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            // ─ Bloc date ─
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(children: [
                Text(
                  DateFormat('dd', 'fr').format(scrutin.dateScrutin),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                      color: AppColors.primary),
                ),
                Text(
                  DateFormat('MMM', 'fr').format(scrutin.dateScrutin).toUpperCase(),
                  style: const TextStyle(fontSize: 10, color: AppColors.primary),
                ),
                Text(
                  DateFormat('yyyy').format(scrutin.dateScrutin),
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ]),
            ),
            const SizedBox(width: 14),
            // ─ Infos ─
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(scrutin.titre,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  _Chip(labelType, AppColors.accent),
                  const SizedBox(width: 6),
                  _Chip(_labelStatut(scrutin.statut), couleurStatut),
                ]),
              ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ]),
        ),
      ),
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

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.couleur);
  final String label;
  final Color  couleur;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: couleur.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(color: couleur, fontSize: 10, fontWeight: FontWeight.w600)),
      );
}

// ─── Formulaire nouveau scrutin ───────────────────────────────────────────────

class _FormScrutin extends StatefulWidget {
  const _FormScrutin({required this.onSave});
  final Future<void> Function(ParamsAjouterScrutin) onSave;

  @override
  State<_FormScrutin> createState() => _FormScrutinState();
}

class _FormScrutinState extends State<_FormScrutin> {
  final _formKey    = GlobalKey<FormState>();
  final _titreCtrl  = TextEditingController();
  final _descCtrl   = TextEditingController();
  String    _type         = AppEnums.scrutinInterne;
  DateTime  _dateScrutin  = DateTime.now().add(const Duration(days: 7));
  bool      _enEnvoi      = false;

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateScrutin,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (d != null) setState(() => _dateScrutin = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enEnvoi = true);
    await widget.onSave(ParamsAjouterScrutin(
      titre:       _titreCtrl.text.trim(),
      type:        _type,
      dateScrutin: _dateScrutin,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
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
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Poignée
          Center(
            child: Container(width: 36, height: 4,
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 16),
          const Text('Nouveau scrutin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),

          TextFormField(
            controller: _titreCtrl,
            decoration: const InputDecoration(labelText: 'Titre *', border: OutlineInputBorder()),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Titre requis' : null,
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _type,
            decoration: const InputDecoration(labelText: 'Type *', border: OutlineInputBorder()),
            items: AppEnums.typesScrutin
                .map((t) => DropdownMenuItem(value: t.$1, child: Text(t.$2)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 12),

          // Date picker
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date du scrutin *',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
              ),
              child: Text(DateFormat('dd MMMM yyyy', 'fr').format(_dateScrutin)),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'Description (optionnel)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enEnvoi ? null : _submit,
              child: _enEnvoi
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Créer le scrutin'),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Vue erreur ───────────────────────────────────────────────────────────────

class _ErreurVue extends StatelessWidget {
  const _ErreurVue({required this.failure, required this.onRetry});
  final Failure    failure;
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