import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/rapports_provider.dart';

// Provider liste des unités accessibles
final _unitesDispoProvider = FutureProvider.autoDispose<List<({String id, String label})>>(
  (ref) async {
    final supabase = ref.watch(supabaseClientProvider);
    final data = await supabase
        .from(AppTables.unitesOrganisationnelles)
        .select('${AppTables.colId}, ${AppTables.colNom}, ${AppTables.colCode}')
        .order(AppTables.colNom);
    return (data as List)
        .map((u) => (
          id:    u[AppTables.colId]  as String,
          label: (u[AppTables.colCode] as String?) ?? (u[AppTables.colNom] as String),
        ))
        .toList();
  },
);

class RapportActiviteFormPage extends ConsumerStatefulWidget {
  const RapportActiviteFormPage({super.key});

  @override
  ConsumerState<RapportActiviteFormPage> createState() =>
      _RapportActiviteFormPageState();
}

class _RapportActiviteFormPageState
    extends ConsumerState<RapportActiviteFormPage> {
  // Périmètre
  String? _uniteId; // null = global

  // Période
  int _debutJour  = 1;
  int _debutMois  = 1;
  int _debutAnnee = DateTime.now().year;
  int _finJour    = DateTime.now().day;
  int _finMois    = DateTime.now().month;
  int _finAnnee   = DateTime.now().year;

  static int _nbJours(int mois, int annee) => DateTime(annee, mois + 1, 0).day;

  void _setDebutMois(int? v) {
    if (v == null) return;
    setState(() {
      _debutMois = v;
      _debutJour = _debutJour.clamp(1, _nbJours(v, _debutAnnee));
    });
  }

  void _setDebutAnnee(int? v) {
    if (v == null) return;
    setState(() {
      _debutAnnee = v;
      _debutJour  = _debutJour.clamp(1, _nbJours(_debutMois, v));
    });
  }

  void _setFinMois(int? v) {
    if (v == null) return;
    setState(() {
      _finMois = v;
      _finJour = _finJour.clamp(1, _nbJours(v, _finAnnee));
    });
  }

  void _setFinAnnee(int? v) {
    if (v == null) return;
    setState(() {
      _finAnnee = v;
      _finJour  = _finJour.clamp(1, _nbJours(_finMois, v));
    });
  }

  // Sections
  bool _militants  = true;
  bool _prospects  = true;
  bool _finances   = true;
  bool _evenements = true;
  bool _reunions   = true;
  bool _bureau     = true;

  bool _estGlobal(String? role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(rapportActiviteProvider, (_, next) {
        next.whenOrNull(
          pret: (bytes, nom) async {
            await Printing.sharePdf(bytes: bytes, filename: nom);
            if (mounted) {
              ref.read(rapportActiviteProvider.notifier).reinitialiser();
              Navigator.of(context).pop();
            }
          },
          erreur: (msg) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erreur : $msg'),
              backgroundColor: AppColors.secondary,
            ));
            ref.read(rapportActiviteProvider.notifier).reinitialiser();
          },
        );
      });
    });
  }

  void _generer() {
    final debut = DateTime(_debutAnnee, _debutMois, _debutJour);
    final fin   = DateTime(_finAnnee,   _finMois,   _finJour, 23, 59, 59);
    if (fin.isBefore(debut)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('La date de fin doit être après la date de début'),
        backgroundColor: AppColors.secondary,
      ));
      return;
    }
    if (!_militants && !_prospects && !_finances && !_evenements && !_reunions && !_bureau) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sélectionnez au moins une section'),
        backgroundColor: AppColors.secondary,
      ));
      return;
    }
    ref.read(rapportActiviteProvider.notifier).generer(
      uniteId:          _uniteId,
      debut:            debut,
      fin:              fin,
      inclureMilitants:  _militants,
      inclureProspects:  _prospects,
      inclureFinances:   _finances,
      inclureEvenements: _evenements,
      inclureReunions:   _reunions,
      inclureBureau:     _bureau,
    );
  }

  @override
  Widget build(BuildContext context) {
    final etat    = ref.watch(rapportActiviteProvider);
    final enCours = etat.maybeWhen(generation: () => true, orElse: () => false);
    final user    = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final global  = _estGlobal(user?.role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Rapport d\'Activité',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Personnalisez votre rapport PDF',
              style: TextStyle(fontSize: 13, color: AppColors.text2)),
          const SizedBox(height: 16),

          // ── Périmètre ───────────────────────────────────────────────────
          _Carte(
            titre: 'PÉRIMÈTRE',
            child: global
                ? _PerimetreGlobal(
                    uniteId: _uniteId,
                    onChanged: (id) => setState(() => _uniteId = id),
                  )
                : _ligneInfo('Unité', user?.uniteOrganisationnelleId ?? '—'),
          ),
          const SizedBox(height: 12),

          // ── Période ─────────────────────────────────────────────────────
          _Carte(
            titre: 'PÉRIODE',
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Du',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.text2)),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(flex: 1, child: _DropdownJour(
                  valeur:   _debutJour,
                  mois:     _debutMois,
                  annee:    _debutAnnee,
                  onChanged: (v) => setState(() => _debutJour = v!),
                )),
                const SizedBox(width: 6),
                Expanded(flex: 2, child: _DropdownMois(
                  valeur:    _debutMois,
                  onChanged: _setDebutMois,
                )),
                const SizedBox(width: 6),
                Expanded(flex: 2, child: _DropdownAnnee(
                  valeur:    _debutAnnee,
                  onChanged: _setDebutAnnee,
                )),
              ]),
              const SizedBox(height: 12),
              const Text('Au',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.text2)),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(flex: 1, child: _DropdownJour(
                  valeur:    _finJour,
                  mois:      _finMois,
                  annee:     _finAnnee,
                  onChanged: (v) => setState(() => _finJour = v!),
                )),
                const SizedBox(width: 6),
                Expanded(flex: 2, child: _DropdownMois(
                  valeur:    _finMois,
                  onChanged: _setFinMois,
                )),
                const SizedBox(width: 6),
                Expanded(flex: 2, child: _DropdownAnnee(
                  valeur:    _finAnnee,
                  onChanged: _setFinAnnee,
                )),
              ]),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Sections ────────────────────────────────────────────────────
          _Carte(
            titre: 'SECTIONS À INCLURE',
            child: Column(children: [
              _SectionSwitch(
                icone: Icons.people_outlined,
                label: 'Militants',
                sousTitre: 'Effectifs, sexe, taux de recouvrement',
                value: _militants,
                onChanged: (v) => setState(() => _militants = v),
              ),
              _SectionSwitch(
                icone: Icons.person_add_outlined,
                label: 'Prospects',
                sousTitre: 'Entonnoir par étape',
                value: _prospects,
                onChanged: (v) => setState(() => _prospects = v),
              ),
              _SectionSwitch(
                icone: Icons.account_balance_wallet_outlined,
                label: 'Finances',
                sousTitre: 'Entrées, dépenses, solde, catégories',
                value: _finances,
                onChanged: (v) => setState(() => _finances = v),
              ),
              _SectionSwitch(
                icone: Icons.event_outlined,
                label: 'Événements',
                sousTitre: 'Liste et présences sur la période',
                value: _evenements,
                onChanged: (v) => setState(() => _evenements = v),
              ),
              _SectionSwitch(
                icone: Icons.groups_outlined,
                label: 'Réunions',
                sousTitre: 'Liste et décisions sur la période',
                value: _reunions,
                onChanged: (v) => setState(() => _reunions = v),
              ),
              _SectionSwitch(
                icone: Icons.business_center_outlined,
                label: 'Bureau',
                sousTitre: 'Composition et mandats',
                value: _bureau,
                onChanged: (v) => setState(() => _bureau = v),
                derniere: true,
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Format ──────────────────────────────────────────────────────
          _Carte(
            titre: 'FORMAT',
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.picture_as_pdf_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('PDF', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Bouton ──────────────────────────────────────────────────────
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: enCours ? null : _generer,
              icon: enCours
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.picture_as_pdf_outlined),
              label: Text(
                enCours ? 'Génération en cours…' : 'Générer le rapport',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Le PDF sera ouvert dans le partage système',
              style: TextStyle(fontSize: 11, color: AppColors.text2),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _ligneInfo(String label, String valeur) => Row(children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.text2)),
        const SizedBox(width: 8),
        Text(valeur, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text)),
      ]);
}

// ─── Périmètre global (BEX) ───────────────────────────────────────────────────

class _PerimetreGlobal extends ConsumerWidget {
  const _PerimetreGlobal({required this.uniteId, required this.onChanged});
  final String?                 uniteId;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unites = ref.watch(_unitesDispoProvider);
    return unites.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Text('Impossible de charger les unités',
          style: TextStyle(color: AppColors.secondary)),
      data: (list) => DropdownButtonFormField<String?>(
        value: uniteId,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('PASTEF France — Global'),
          ),
          ...list.map((u) => DropdownMenuItem<String?>(
            value: u.id,
            child: Text(u.label, overflow: TextOverflow.ellipsis),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

// ─── Widgets utilitaires ──────────────────────────────────────────────────────

class _Carte extends StatelessWidget {
  const _Carte({required this.titre, required this.child});
  final String titre;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titre,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.text2, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          child,
        ]),
      );
}

class _SectionSwitch extends StatelessWidget {
  const _SectionSwitch({
    required this.icone,
    required this.label,
    required this.sousTitre,
    required this.value,
    required this.onChanged,
    this.derniere = false,
  });
  final IconData icone;
  final String   label;
  final String   sousTitre;
  final bool     value;
  final ValueChanged<bool> onChanged;
  final bool     derniere;

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, size: 18,
                color: value ? AppColors.primary : AppColors.text2),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                color: value ? AppColors.text : AppColors.text2)),
            Text(sousTitre, style: const TextStyle(fontSize: 11, color: AppColors.text2)),
          ])),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ]),
        if (!derniere) const Divider(height: 16, indent: 48),
      ]);
}

class _DropdownJour extends StatelessWidget {
  const _DropdownJour({
    required this.valeur,
    required this.mois,
    required this.annee,
    required this.onChanged,
  });
  final int valeur;
  final int mois;
  final int annee;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final nbJours = DateTime(annee, mois + 1, 0).day;
    return DropdownButtonFormField<int>(
      value: valeur.clamp(1, nbJours),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      items: List.generate(nbJours, (i) => i + 1)
          .map((j) => DropdownMenuItem(value: j, child: Text('$j')))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DropdownMois extends StatelessWidget {
  const _DropdownMois({required this.valeur, required this.onChanged});
  final int valeur;
  final ValueChanged<int?> onChanged;

  static const _labels = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<int>(
        value: valeur,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        items: List.generate(12, (i) => i + 1)
            .map((m) => DropdownMenuItem(value: m, child: Text(_labels[m], overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
      );
}

class _DropdownAnnee extends StatelessWidget {
  const _DropdownAnnee({required this.valeur, required this.onChanged});
  final int valeur;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<int>(
        value: valeur,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        items: List.generate(5, (i) => DateTime.now().year - i)
            .map((a) => DropdownMenuItem(value: a, child: Text('$a')))
            .toList(),
        onChanged: onChanged,
      );
}