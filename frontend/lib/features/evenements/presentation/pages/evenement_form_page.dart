import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/repositories/evenements_repository.dart';

class EvenementFormPage extends ConsumerStatefulWidget {
  const EvenementFormPage({super.key});

  @override
  ConsumerState<EvenementFormPage> createState() => _EvenementFormPageState();
}

class _EvenementFormPageState extends ConsumerState<EvenementFormPage> {
  final _formKey     = GlobalKey<FormState>();
  final _titreCtrl   = TextEditingController();
  final _descCtrl    = TextEditingController();
  final _lieuCtrl    = TextEditingController();

  String    _type      = AppEnums.typeAutre;
  DateTime  _dateDebut = DateTime.now().add(const Duration(days: 1));
  DateTime? _dateFin;

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

    final utilisateur = ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) return;

    Navigator.of(context).pop(
      ParamsAjouterEvenement(
        titre:       _titreCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        dateDebut:   _dateDebut,
        dateFin:     _dateFin,
        lieu:        _lieuCtrl.text.trim(),
        type:        _type,
        uniteId:     utilisateur.uniteOrganisationnelleId ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'fr');
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
            _Section('Date et heure'),
            _DateTile(
              label: 'Début',
              valeur: fmt.format(_dateDebut),
              obligatoire: true,
              onTap: _choisirDateDebut,
            ),
            const SizedBox(height: 8),
            _DateTile(
              label: 'Fin (optionnel)',
              valeur: _dateFin != null ? fmt.format(_dateFin!) : 'Non définie',
              obligatoire: false,
              onTap: _choisirDateFin,
            ),
            if (_dateFin != null)
              TextButton.icon(
                onPressed: () => setState(() => _dateFin = null),
                icon: const Icon(Icons.clear, size: 14),
                label: const Text('Supprimer la date de fin'),
                style: TextButton.styleFrom(foregroundColor: AppColors.text2),
              ),
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _soumettre,
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

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(titre.toUpperCase(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
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
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
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
          filled: true,
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 11, color: AppColors.text2)),
              Text(valeur,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.text)),
            ]),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: AppColors.text2),
          ]),
        ),
      );
}