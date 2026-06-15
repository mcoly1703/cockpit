import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../militants/domain/entities/unite_organisationnelle.dart';
import '../../../militants/presentation/providers/militants_provider.dart';
import '../../domain/repositories/reunions_repository.dart';

class ReunionFormPage extends ConsumerStatefulWidget {
  const ReunionFormPage({super.key});

  @override
  ConsumerState<ReunionFormPage> createState() => _ReunionFormPageState();
}

class _ReunionFormPageState extends ConsumerState<ReunionFormPage> {
  final _formKey       = GlobalKey<FormState>();
  final _titreCtrl     = TextEditingController();
  final _lieuCtrl      = TextEditingController();
  final _ordreJourCtrl = TextEditingController();

  String   _type    = AppEnums.typeReunionAutre;
  DateTime _date    = DateTime.now().add(const Duration(days: 1));
  String?  _uniteId;  // null → auto depuis le profil

  @override
  void dispose() {
    _titreCtrl.dispose();
    _lieuCtrl.dispose();
    _ordreJourCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    if (t == null || !mounted) return;
    setState(() => _date = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  void _soumettre(String fallbackUniteId) {
    if (!_formKey.currentState!.validate()) return;
    final uniteId = _uniteId ?? fallbackUniteId;
    if (uniteId.isEmpty) return;

    Navigator.of(context).pop(
      ParamsAjouterReunion(
        titre:     _titreCtrl.text.trim(),
        type:      _type,
        date:      _date,
        lieu:      _lieuCtrl.text.trim(),
        ordreJour: _ordreJourCtrl.text.trim().isEmpty ? null : _ordreJourCtrl.text.trim(),
        uniteId:   uniteId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt          = DateFormat('dd/MM/yyyy HH:mm', 'fr');
    final utilisateur  = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final role         = utilisateur?.role ?? '';
    final monUniteId   = utilisateur?.uniteOrganisationnelleId ?? '';
    final estGlobal    = role == AppRoles.bureauExecutif ||
                         role == AppRoles.coordinateur   ||
                         role == AppRoles.adminTechnique;

    // Unités disponibles pour le sélecteur (rôles globaux uniquement)
    final militantsState = ref.watch(militantsProvider);
    final unites = militantsState.maybeWhen(
      charge: (_, u, a, b) => u,
      orElse: () => <UniteOrganisationnelle>[],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nouvelle réunion'),
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
            _Champ(ctrl: _lieuCtrl, label: 'Lieu', obligatoire: true),
            const SizedBox(height: 12),
            _DropdownType(
              valeur:    _type,
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 20),

            _Section('Entité organisatrice'),
            if (estGlobal && unites.isNotEmpty)
              _DropdownUnite(
                unites:    unites,
                valeur:    _uniteId,
                onChanged: (v) => setState(() => _uniteId = v),
              )
            else
              _UniteLectureSeule(
                nomUnite: unites.isEmpty
                    ? monUniteId
                    : unites
                          .where((u) => u.id == monUniteId)
                          .map((u) => u.nom)
                          .firstOrNull ?? monUniteId,
              ),
            const SizedBox(height: 20),

            _Section('Date et heure'),
            _DateTile(
              label:  'Date de la réunion',
              valeur: fmt.format(_date),
              onTap:  _choisirDate,
            ),
            const SizedBox(height: 20),

            _Section('Ordre du jour (optionnel)'),
            _Champ(
              ctrl:     _ordreJourCtrl,
              label:    'Points à aborder',
              maxLines: 5,
            ),
            const SizedBox(height: 28),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => _soumettre(monUniteId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Créer la réunion',
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
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
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
          labelText: 'Type de réunion',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
        ),
        items: AppEnums.typesReunion
            .map((t) => DropdownMenuItem(value: t.$1, child: Text(t.$2)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Champ requis' : null,
      );
}

String _labelTypeUnite(String type) => switch (type) {
  AppUniteTypes.bureauExecutif => 'Bureau Exécutif',
  AppUniteTypes.sousSection    => 'Sous-section',
  AppUniteTypes.mouvement      => 'Mouvement',
  AppUniteTypes.secretariat    => 'Secrétariat',
  AppUniteTypes.cellule        => 'Cellule',
  _                            => type,
};

class _DropdownUnite extends StatelessWidget {
  const _DropdownUnite({
    required this.unites,
    required this.valeur,
    required this.onChanged,
  });
  final List<UniteOrganisationnelle> unites;
  final String?                      valeur;
  final void Function(String?)       onChanged;

  @override
  Widget build(BuildContext context) {
    final sorted = [...unites]..sort((a, b) {
        const ordre = [
          AppUniteTypes.bureauExecutif,
          AppUniteTypes.sousSection,
          AppUniteTypes.mouvement,
          AppUniteTypes.secretariat,
          AppUniteTypes.cellule,
        ];
        final ia = ordre.indexOf(a.type);
        final ib = ordre.indexOf(b.type);
        if (ia != ib) return ia.compareTo(ib);
        return a.nom.compareTo(b.nom);
      });

    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: valeur,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Entité organisatrice',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: AppColors.card,
      ),
      items: sorted.map((u) => DropdownMenuItem(
        value: u.id,
        child: Text(
          '${_labelTypeUnite(u.type)} · ${u.nom}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      )).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Champ requis' : null,
    );
  }
}

class _UniteLectureSeule extends StatelessWidget {
  const _UniteLectureSeule({required this.nomUnite});
  final String nomUnite;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.business_outlined, size: 18, color: AppColors.text2),
          const SizedBox(width: 10),
          Expanded(
            child: Text(nomUnite,
                style: const TextStyle(fontSize: 14, color: AppColors.text)),
          ),
        ]),
      );
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.valeur,
    required this.onTap,
  });
  final String       label;
  final String       valeur;
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
            const Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: AppColors.text2)),
              Text(valeur,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.text)),
            ]),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.text2),
          ]),
        ),
      );
}