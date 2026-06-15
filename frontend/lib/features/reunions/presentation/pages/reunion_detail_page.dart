import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:web/web.dart' as web;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/decision.dart';
import '../../domain/entities/reunion.dart';
import '../../domain/repositories/reunions_repository.dart';
import '../providers/reunions_provider.dart';

class ReunionDetailPage extends ConsumerWidget {
  const ReunionDetailPage({super.key, required this.reunion});
  final Reunion reunion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Toujours lire la version la plus récente depuis le provider
    final reunionCourante = ref.watch(reunionsProvider).toutes
        .firstWhere((r) => r.id == reunion.id, orElse: () => reunion);

    final decisionsState = ref.watch(decisionsProvider(reunion.id));
    final fmt = DateFormat('EEEE dd MMMM yyyy · HH:mm', 'fr');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(reunionCourante.titre, overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(reunion: reunionCourante, fmt: fmt),
          const SizedBox(height: 12),
          _CompteRenduCard(reunion: reunionCourante),
          const SizedBox(height: 12),
          decisionsState.when(
            initial:    () => const SizedBox.shrink(),
            chargement: () => const Center(child: CircularProgressIndicator()),
            erreur: (_) => const Text('Erreur chargement décisions',
                style: TextStyle(color: AppColors.secondary)),
            charge: (decisions) => _DecisionsCard(
              decisions: decisions,
              reunion:   reunionCourante,
              onAjouter: () => _ajouterDecision(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ajouterDecision(BuildContext context, WidgetRef ref) async {
    final params = await showDialog<ParamsAjouterDecision>(
      context: context,
      builder: (_) => _DialogDecision(reunionId: reunion.id),
    );
    if (params == null || !context.mounted) return;

    final result = await ref
        .read(decisionsProvider(reunion.id).notifier)
        .ajouterDecision(params);
    if (!context.mounted) return;
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur'),
              backgroundColor: AppColors.secondary)),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Décision ajoutée'),
              backgroundColor: AppColors.primary)),
    );
  }
}

// ─── Infos réunion ────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.reunion, required this.fmt});
  final Reunion    reunion;
  final DateFormat fmt;

  String _labelType(String type) =>
      AppEnums.typesReunion.firstWhere((t) => t.$1 == type,
          orElse: () => (type, type)).$2;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_labelType(reunion.type),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const SizedBox(height: 12),
          _InfoLigne(Icons.calendar_today_outlined, fmt.format(reunion.date)),
          const SizedBox(height: 6),
          _InfoLigne(Icons.location_on_outlined, reunion.lieu),
          if (reunion.ordreJour != null) ...[
            const Divider(height: 20),
            const Text('ORDRE DU JOUR',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: AppColors.text2, letterSpacing: 0.8)),
            const SizedBox(height: 6),
            Text(reunion.ordreJour!,
                style: const TextStyle(fontSize: 13, color: AppColors.text2)),
          ],
        ]),
      );
}

class _InfoLigne extends StatelessWidget {
  const _InfoLigne(this.icone, this.texte);
  final IconData icone;
  final String   texte;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icone, size: 16, color: AppColors.text2),
        const SizedBox(width: 8),
        Expanded(child: Text(texte,
            style: const TextStyle(fontSize: 13, color: AppColors.text))),
      ]);
}

// ─── Compte Rendu ─────────────────────────────────────────────────────────────

class _CompteRenduCard extends ConsumerStatefulWidget {
  const _CompteRenduCard({required this.reunion});
  final Reunion reunion;

  @override
  ConsumerState<_CompteRenduCard> createState() => _CompteRenduCardState();
}

class _CompteRenduCardState extends ConsumerState<_CompteRenduCard> {
  bool    _enCours = false;
  String? _erreur;

  Future<void> _redigerCR() async {
    final texte = await showDialog<String>(
      context: context,
      builder: (_) => _DialogCR(texteInitial: widget.reunion.compteRendu),
    );
    if (texte == null || !mounted) return;

    setState(() { _enCours = true; _erreur = null; });
    final result = await ref.read(reunionsProvider.notifier).mettreAJourCR(
      ParamsMettreAJourCR(
        reunionId:   widget.reunion.id,
        compteRendu: texte,
      ),
    );
    result.fold(
      (f) => setState(() { _enCours = false; _erreur = 'Erreur enregistrement'; }),
      (_) => setState(() { _enCours = false; }),
    );
  }

  Future<void> _uploaderCR() async {
    final result = await FilePicker.platform.pickFiles(
      type:          FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      withData:      true,
    );
    if (result == null || result.files.single.bytes == null || !mounted) return;

    setState(() { _enCours = true; _erreur = null; });
    final bytes = result.files.single.bytes!;
    final ext   = (result.files.single.extension ?? 'pdf').toLowerCase();

    final either = await ref.read(reunionsProvider.notifier).uploaderEtSauvegarderCR(
      ParamsUploaderFichierCR(
        reunionId: widget.reunion.id,
        bytes:     bytes,
        extension: ext,
      ),
    );
    either.fold(
      (_) => setState(() { _enCours = false; _erreur = 'Erreur upload'; }),
      (_) => setState(() { _enCours = false; }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reunion = ref.watch(reunionsProvider).toutes
        .firstWhere((r) => r.id == widget.reunion.id, orElse: () => widget.reunion);
    final hasCR    = (reunion.compteRendu?.isNotEmpty ?? false);
    final hasFile  = reunion.compteRenduUrl != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('COMPTE RENDU',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                    color: AppColors.text2, letterSpacing: 0.8)),
            Text(hasCR || hasFile ? 'Disponible' : 'Non rédigé',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: hasCR || hasFile
                        ? AppColors.primary
                        : AppColors.text2)),
          ])),
          if (_enCours) const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
          else ...[
            _BoutonCR(
              icone:   Icons.edit_note_rounded,
              label:   hasCR ? 'Modifier' : 'Rédiger',
              couleur: AppColors.primary,
              onTap:   _redigerCR,
            ),
            const SizedBox(width: 8),
            _BoutonCR(
              icone:   Icons.upload_file_rounded,
              label:   hasFile ? 'Remplacer' : 'Uploader',
              couleur: AppColors.accent,
              onTap:   _uploaderCR,
            ),
          ],
        ]),

        if (_erreur != null) ...[
          const SizedBox(height: 8),
          Text(_erreur!,
              style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
        ],

        if (hasCR) ...[
          const Divider(height: 20),
          Text(reunion.compteRendu!,
              style: const TextStyle(fontSize: 13, color: AppColors.text, height: 1.5)),
        ],

        if (hasFile) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => web.window.open(reunion.compteRenduUrl!, '_blank'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.description_outlined,
                    size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Fichier CR joint — Ouvrir',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.accent,
                          fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.open_in_new_rounded,
                    size: 14, color: AppColors.accent),
              ]),
            ),
          ),
        ],
      ]),
    );
  }
}

class _BoutonCR extends StatelessWidget {
  const _BoutonCR({
    required this.icone,
    required this.label,
    required this.couleur,
    required this.onTap,
  });
  final IconData     icone;
  final String       label;
  final Color        couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: couleur.withValues(alpha: 0.3)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icone, size: 14, color: couleur),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: couleur)),
          ]),
        ),
      );
}

// ─── Dialog rédaction CR ──────────────────────────────────────────────────────

class _DialogCR extends StatefulWidget {
  const _DialogCR({this.texteInitial});
  final String? texteInitial;

  @override
  State<_DialogCR> createState() => _DialogCRState();
}

class _DialogCRState extends State<_DialogCR> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.texteInitial ?? '');
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Compte rendu de réunion'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: _ctrl,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Rédigez le compte rendu…',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_ctrl.text.trim()),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Enregistrer'),
          ),
        ],
      );
}

// ─── Décisions ────────────────────────────────────────────────────────────────

class _DecisionsCard extends ConsumerWidget {
  const _DecisionsCard({
    required this.decisions,
    required this.reunion,
    required this.onAjouter,
  });
  final List<Decision> decisions;
  final Reunion        reunion;
  final VoidCallback   onAjouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('DÉCISIONS',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: AppColors.text2, letterSpacing: 0.8)),
              Text('${decisions.length} décision${decisions.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                      color: AppColors.text)),
            ])),
            ElevatedButton.icon(
              onPressed: onAjouter,
              icon: const Icon(Icons.add_outlined, size: 16),
              label: const Text('Ajouter', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
          if (decisions.isEmpty) ...[
            const SizedBox(height: 16),
            const Center(child: Text('Aucune décision enregistrée',
                style: TextStyle(fontSize: 13, color: AppColors.text2))),
          ] else ...[
            const Divider(height: 20),
            ...decisions.map((d) => _DecisionTile(
              decision:  d,
              reunionId: reunion.id,
            )),
          ],
        ]),
      );
}

class _DecisionTile extends ConsumerWidget {
  const _DecisionTile({required this.decision, required this.reunionId});
  final Decision decision;
  final String   reunionId;

  static const _statuts = [
    (AppEnums.decisionEnAttente, 'En attente'),
    (AppEnums.decisionEnCours,   'En cours'),
    (AppEnums.decisionTerminee,  'Terminée'),
    (AppEnums.decisionAbandon,   'Abandonnée'),
  ];

  Color _couleurStatut(String s) => switch (s) {
    AppEnums.decisionEnAttente => AppColors.accent,
    AppEnums.decisionEnCours   => AppColors.primary,
    AppEnums.decisionTerminee  => const Color(0xFF2E7D32),
    _                          => AppColors.secondary,
  };

  String _labelStatut(String s) =>
      _statuts.firstWhere((t) => t.$1 == s, orElse: () => (s, s)).$2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couleur = _couleurStatut(decision.statut);
    final fmtDate = DateFormat('dd/MM/yy', 'fr');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 4, height: 60,
          decoration: BoxDecoration(
            color: couleur, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(decision.texte,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: AppColors.text)),
          const SizedBox(height: 4),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(_labelStatut(decision.statut),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: couleur)),
            ),
            if (decision.responsable != null) ...[
              const SizedBox(width: 6),
              Text('→ ${decision.responsable}',
                  style: const TextStyle(fontSize: 11, color: AppColors.text2)),
            ],
            if (decision.echeance != null) ...[
              const SizedBox(width: 6),
              Text('· ${fmtDate.format(decision.echeance!)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.text2)),
            ],
          ]),
        ])),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 18, color: AppColors.text2),
          onSelected: (statut) => ref
              .read(decisionsProvider(reunionId).notifier)
              .modifierStatut(decision.id, statut),
          itemBuilder: (_) => _statuts
              .where((t) => t.$1 != decision.statut)
              .map((t) => PopupMenuItem(value: t.$1, child: Text(t.$2)))
              .toList(),
        ),
      ]),
    );
  }
}

// ─── Dialog ajout décision ────────────────────────────────────────────────────

class _DialogDecision extends StatefulWidget {
  const _DialogDecision({required this.reunionId});
  final String reunionId;

  @override
  State<_DialogDecision> createState() => _DialogDecisionState();
}

class _DialogDecisionState extends State<_DialogDecision> {
  final _texteCtrl       = TextEditingController();
  final _responsableCtrl = TextEditingController();
  final _formKey         = GlobalKey<FormState>();
  DateTime? _echeance;

  @override
  void dispose() {
    _texteCtrl.dispose();
    _responsableCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirEcheance() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _echeance ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d != null && mounted) setState(() => _echeance = d);
  }

  @override
  Widget build(BuildContext context) {
    final fmtDate = DateFormat('dd/MM/yyyy', 'fr');
    return AlertDialog(
      title: const Text('Nouvelle décision'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _texteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Décision *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _responsableCtrl,
              decoration: const InputDecoration(labelText: 'Responsable (optionnel)'),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _choisirEcheance,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Échéance (optionnel)'),
                child: Text(
                  _echeance != null ? fmtDate.format(_echeance!) : 'Non définie',
                  style: TextStyle(
                    fontSize: 14,
                    color: _echeance != null ? AppColors.text : AppColors.text2,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              ParamsAjouterDecision(
                reunionId:   widget.reunionId,
                texte:       _texteCtrl.text.trim(),
                responsable: _responsableCtrl.text.trim().isEmpty
                    ? null
                    : _responsableCtrl.text.trim(),
                echeance: _echeance,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}