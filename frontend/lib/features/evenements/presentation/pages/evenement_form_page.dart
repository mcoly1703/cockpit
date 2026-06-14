import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../militants/domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/evenements_repository.dart';
import '../providers/evenements_provider.dart';

class EvenementFormPage extends ConsumerStatefulWidget {
  const EvenementFormPage({super.key});

  @override
  ConsumerState<EvenementFormPage> createState() => _EvenementFormPageState();
}

class _EvenementFormPageState extends ConsumerState<EvenementFormPage> {
  final _formKey   = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _lieuCtrl  = TextEditingController();

  String    _type      = AppEnums.typeAutre;
  DateTime  _dateDebut = DateTime.now().add(const Duration(days: 1));
  DateTime? _dateFin;
  String?   _uniteId;

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descCtrl.dispose();
    _lieuCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDateDebut() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateDebut,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateDebut),
    );
    if (t == null || !mounted) return;
    setState(() => _dateDebut = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  Future<void> _choisirDateFin() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateFin ?? _dateDebut,
      firstDate: _dateDebut,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateFin ?? _dateDebut),
    );
    if (t == null || !mounted) return;
    setState(() => _dateFin = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;
    if (_uniteId == null) return;

    Navigator.of(context).pop(
      ParamsAjouterEvenement(
        titre:       _titreCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        dateDebut:   _dateDebut,
        dateFin:     _dateFin,
        lieu:        _lieuCtrl.text.trim(),
        type:        _type,
        uniteId:     _uniteId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur  = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final unitesAsync  = ref.watch(unitesEvenementsProvider);
    final fmt          = DateFormat('dd/MM/yyyy HH:mm', 'fr');

    // Initialise l'unité sur celle de l'utilisateur connecté dès que la liste est chargée
    unitesAsync.whenData((unites) {
      if (_uniteId == null) {
        final defaut = utilisateur?.uniteOrganisationnelleId;
        final existe = defaut != null && unites.any((u) => u.id == defaut);
        if (mounted) {
          setState(() => _uniteId = existe ? defaut : (unites.isNotEmpty ? unites.first.id : null));
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nouvel événement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section('Informations'),
            _Champ(ctrl: _titreCtrl, label: 'Titre', obligatoire: true),
            const SizedBox(height: 12),
            _Champ(ctrl: _descCtrl, label: 'Description (optionnel)', maxLines: 3),
            const SizedBox(height: 12),
            _Champ(ctrl: _lieuCtrl, label: 'Lieu', obligatoire: true),
            const SizedBox(height: 12),
            _DropdownType(valeur: _type, onChanged: (v) => setState(() => _type = v!)),
            const SizedBox(height: 20),

            _Section('Organisateur'),
            unitesAsync.when(
              data: (unites) => _SelecteurUnite(
                unites:   unites,
                valeur:   _uniteId,
                onChanged: (id) => setState(() => _uniteId = id),
              ),
              loading: () => const _ChargementUnites(),
              error:   (_, __) => const _ErreurUnites(),
            ),
            const SizedBox(height: 20),

            _Section('Date et heure'),
            _DateTile(
              label:        'Début',
              valeur:       fmt.format(_dateDebut),
              obligatoire:  true,
              onTap:        _choisirDateDebut,
            ),
            const SizedBox(height: 8),
            _DateTile(
              label:       'Fin (optionnel)',
              valeur:      _dateFin != null ? fmt.format(_dateFin!) : 'Non définie',
              obligatoire: false,
              onTap:       _choisirDateFin,
            ),
            if (_dateFin != null)
              TextButton.icon(
                onPressed: () => setState(() => _dateFin = null),
                icon:  const Icon(Icons.clear, size: 14),
                label: const Text('Supprimer la date de fin'),
                style: TextButton.styleFrom(foregroundColor: AppColors.text2),
              ),
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _uniteId != null ? _soumettre : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Créer l\'événement',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sélecteur d'unité organisatrice ─────────────────────────────────────────

class _SelecteurUnite extends StatelessWidget {
  const _SelecteurUnite({
    required this.unites,
    required this.valeur,
    required this.onChanged,
  });

  final List<UniteOrganisationnelle> unites;
  final String?                      valeur;
  final void Function(String?)       onChanged;

  // Ordre et libellés des groupes
  static const _groupes = [
    (AppUniteTypes.bureauExecutif, 'Section France'),
    (AppUniteTypes.sousSection,    'Sous-sections'),
    (AppUniteTypes.mouvement,      'Mouvements'),
    (AppUniteTypes.secretariat,    'Secrétariats'),
    (AppUniteTypes.cellule,        'Cellules'),
  ];

  List<DropdownMenuItem<String>> _construireItems() {
    final items = <DropdownMenuItem<String>>[];

    for (final (typeVal, typeLabel) in _groupes) {
      final groupe = unites.where((u) => u.type == typeVal).toList();
      if (groupe.isEmpty) continue;

      // En-tête de groupe (non sélectionnable)
      items.add(DropdownMenuItem<String>(
        enabled: false,
        value: '__header_$typeVal',
        child: Text(
          typeLabel.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.text2,
            letterSpacing: 0.8,
          ),
        ),
      ));

      for (final u in groupe) {
        items.add(DropdownMenuItem<String>(
          value: u.id,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              u.nom,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.text),
            ),
          ),
        ));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _construireItems();
    // Vérifie que la valeur actuelle est dans les items sélectionnables
    final valeurValide = items.any((i) => i.value == valeur && i.enabled != false)
        ? valeur
        : null;

    return DropdownButtonFormField<String>(
      value:      valeurValide,
      isExpanded: true,
      decoration: InputDecoration(
        labelText:  'Entité organisatrice',
        prefixIcon: const Icon(Icons.account_tree_outlined, color: AppColors.primary),
        border:     OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled:     true,
        fillColor:  AppColors.card,
      ),
      items:     items,
      onChanged: onChanged,
      validator: (v) => v == null ? 'Champ requis' : null,
    );
  }
}

class _ChargementUnites extends StatelessWidget {
  const _ChargementUnites();

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(children: [
          SizedBox(width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 12),
          Text('Chargement des unités…',
              style: TextStyle(fontSize: 14, color: AppColors.text2)),
        ]),
      );
}

class _ErreurUnites extends StatelessWidget {
  const _ErreurUnites();

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(children: [
          Icon(Icons.error_outline, size: 18, color: AppColors.secondary),
          SizedBox(width: 10),
          Text('Impossible de charger les unités',
              style: TextStyle(fontSize: 13, color: AppColors.secondary)),
        ]),
      );
}

// ─── Widgets communs ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(titre.toUpperCase(),
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
      );
}

class _Champ extends StatelessWidget {
  const _Champ({
    required this.ctrl,
    required this.label,
    this.obligatoire = false,
    this.maxLines = 1,
  });
  final TextEditingController ctrl;
  final String label;
  final bool   obligatoire;
  final int    maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        maxLines:   maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled:     true,
          fillColor:  AppColors.card,
        ),
        validator: obligatoire
            ? (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null
            : null,
      );
}

class _DropdownType extends StatelessWidget {
  const _DropdownType({required this.valeur, required this.onChanged});
  final String   valeur;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        // ignore: deprecated_member_use
        value: valeur,
        decoration: InputDecoration(
          labelText: 'Type d\'événement',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled:    true,
          fillColor: AppColors.card,
        ),
        items: AppEnums.typesEvenement
            .map((t) => DropdownMenuItem(value: t.$1, child: Text(t.$2)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Champ requis' : null,
      );
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.valeur,
    required this.obligatoire,
    required this.onTap,
  });
  final String       label;
  final String       valeur;
  final bool         obligatoire;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color:  AppColors.card,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: AppColors.text2)),
              Text(valeur,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
            ]),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.text2),
          ]),
        ),
      );
}