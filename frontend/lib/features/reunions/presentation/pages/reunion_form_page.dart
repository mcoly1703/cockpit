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
  final _formKey        = GlobalKey<FormState>();
  final _titreCtrl      = TextEditingController();
  final _lieuCtrl       = TextEditingController();
  final _ordreJourCtrl  = TextEditingController();

  String _type             = AppEnums.typeReunionInterne;
  bool   _isExtraordinaire = false;
  DateTime _date = DateTime.now().add(const Duration(days: 1));

  // Sélection en cascade
  UniteOrganisationnelle? _niveau1;
  UniteOrganisationnelle? _niveau2;

  bool get _niveau1EstSS => _niveau1?.type == AppUniteTypes.sousSection;

  void _onNiveau1Changed(UniteOrganisationnelle? u) {
    setState(() {
      _niveau1 = u;
      // Pré-sélectionne la SS elle-même pour le niveau 2 par défaut
      _niveau2 = (u?.type == AppUniteTypes.sousSection) ? u : null;
    });
  }

  String _resolveUniteId(String fallback) {
    if (_niveau1EstSS) return (_niveau2 ?? _niveau1)!.id;
    if (_niveau1 != null) return _niveau1!.id;
    return fallback;
  }

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

  void _soumettre(bool estGlobal, String fallbackUniteId) {
    if (!_formKey.currentState!.validate()) return;
    if (estGlobal && _niveau1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez l\'entité organisatrice')),
      );
      return;
    }
    Navigator.of(context).pop(
      ParamsAjouterReunion(
        titre:            _titreCtrl.text.trim(),
        type:             _type,
        date:             _date,
        lieu:             _lieuCtrl.text.trim(),
        ordreJour:        _ordreJourCtrl.text.trim().isEmpty
            ? null
            : _ordreJourCtrl.text.trim(),
        uniteId:          _resolveUniteId(fallbackUniteId),
        isExtraordinaire: _isExtraordinaire,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt         = DateFormat('dd/MM/yyyy HH:mm', 'fr');
    final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final role        = utilisateur?.role ?? '';
    final monUniteId  = utilisateur?.uniteOrganisationnelleId ?? '';
    final estGlobal   = role == AppRoles.bureauExecutif ||
                        role == AppRoles.coordinateur   ||
                        role == AppRoles.adminTechnique;

    final militantsState = ref.watch(militantsProvider);
    final toutesUnites   = militantsState.maybeWhen(
      charge: (_, u, a, b) => u,
      orElse: () => <UniteOrganisationnelle>[],
    );

    // Niveau 1 : tout sauf cellules
    final unitesNiveau1 = toutesUnites
        .where((u) => u.type != AppUniteTypes.cellule)
        .toList()
      ..sort((a, b) {
        const ordre = [
          AppUniteTypes.bureauExecutif,
          AppUniteTypes.sousSection,
          AppUniteTypes.mouvement,
          AppUniteTypes.secretariat,
        ];
        final ia = ordre.indexOf(a.type);
        final ib = ordre.indexOf(b.type);
        if (ia != ib) return ia.compareTo(ib);
        return a.nom.compareTo(b.nom);
      });

    // Niveau 2 : la SS elle-même + ses cellules (si SS sélectionnée)
    final unitesNiveau2 = _niveau1EstSS
        ? [
            _niveau1!,
            ...toutesUnites
                .where((u) =>
                    u.type == AppUniteTypes.cellule &&
                    u.parentId == _niveau1!.id)
                .toList()
              ..sort((a, b) => a.nom.compareTo(b.nom)),
          ]
        : <UniteOrganisationnelle>[];

    // Label du sélecteur niveau 2
    String labelNom(UniteOrganisationnelle u) {
      if (u.id == _niveau1?.id) return '${u.nom} (SS elle-même)';
      return u.nom;
    }

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
            const SizedBox(height: 12),
            _ToggleExtraordinaire(
              valeur:    _isExtraordinaire,
              onChanged: (v) => setState(() => _isExtraordinaire = v),
            ),
            const SizedBox(height: 20),

            _Section('Entité organisatrice'),
            if (estGlobal && toutesUnites.isNotEmpty) ...[
              _AutocompleteUnite(
                key:          const ValueKey('niveau1'),
                unites:       unitesNiveau1,
                label:        'Unité (BEX, sous-section, mouvement…)',
                valeurInitiale: _niveau1,
                labelPourOption: (u) => u.nom,
                onSelected:   _onNiveau1Changed,
              ),
              if (_niveau1EstSS && unitesNiveau2.isNotEmpty) ...[
                const SizedBox(height: 12),
                _AutocompleteUnite(
                  key:          ValueKey('niveau2_${_niveau1!.id}'),
                  unites:       unitesNiveau2,
                  label:        'Cellule (ou la SS elle-même)',
                  valeurInitiale: _niveau2,
                  labelPourOption: labelNom,
                  onSelected:   (u) => setState(() => _niveau2 = u),
                ),
              ],
            ] else
              _UniteLectureSeule(
                nomUnite: toutesUnites.isEmpty
                    ? monUniteId
                    : toutesUnites
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
                onPressed: () => _soumettre(estGlobal, monUniteId),
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

// ─── Autocomplete unité ───────────────────────────────────────────────────────

String _labelTypeUnite(String type) => switch (type) {
  AppUniteTypes.bureauExecutif => 'BEX',
  AppUniteTypes.sousSection    => 'SS',
  AppUniteTypes.mouvement      => 'MVT',
  AppUniteTypes.secretariat    => 'SEC',
  AppUniteTypes.cellule        => 'CEL',
  _                            => type.substring(0, 3).toUpperCase(),
};

Color _couleurTypeUnite(String type) => switch (type) {
  AppUniteTypes.bureauExecutif => AppColors.primary,
  AppUniteTypes.sousSection    => AppColors.primary,
  AppUniteTypes.mouvement      => AppColors.accent,
  AppUniteTypes.secretariat    => const Color(0xFF1A4A8A),
  AppUniteTypes.cellule        => AppColors.text2,
  _                            => AppColors.text2,
};

class _AutocompleteUnite extends StatefulWidget {
  const _AutocompleteUnite({
    super.key,
    required this.unites,
    required this.label,
    required this.labelPourOption,
    required this.onSelected,
    this.valeurInitiale,
  });

  final List<UniteOrganisationnelle>    unites;
  final String                          label;
  final UniteOrganisationnelle?         valeurInitiale;
  final String Function(UniteOrganisationnelle) labelPourOption;
  final void Function(UniteOrganisationnelle?)  onSelected;

  @override
  State<_AutocompleteUnite> createState() => _AutocompleteUniteState();
}

class _AutocompleteUniteState extends State<_AutocompleteUnite> {
  late final TextEditingController _ctrl;
  UniteOrganisationnelle? _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.valeurInitiale;
    _ctrl = TextEditingController(
      text: widget.valeurInitiale != null
          ? widget.labelPourOption(widget.valeurInitiale!)
          : '',
    );
  }

  @override
  void didUpdateWidget(_AutocompleteUnite old) {
    super.didUpdateWidget(old);
    // Si la valeur initiale change (ex: reset du niveau 2), on resynce
    if (old.valeurInitiale?.id != widget.valeurInitiale?.id) {
      _selection = widget.valeurInitiale;
      _ctrl.text = widget.valeurInitiale != null
          ? widget.labelPourOption(widget.valeurInitiale!)
          : '';
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Iterable<UniteOrganisationnelle> _filtrer(TextEditingValue v) {
    final q = v.text.trim().toLowerCase();
    if (q.isEmpty) return widget.unites;
    return widget.unites.where((u) =>
        u.nom.toLowerCase().contains(q) ||
        (u.code?.toLowerCase().contains(q) ?? false));
  }

  @override
  Widget build(BuildContext context) => RawAutocomplete<UniteOrganisationnelle>(
        textEditingController: _ctrl,
        focusNode:             FocusNode(),
        displayStringForOption: widget.labelPourOption,
        optionsBuilder:        _filtrer,
        onSelected: (u) {
          setState(() => _selection = u);
          widget.onSelected(u);
        },
        fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) => TextField(
          controller:  ctrl,
          focusNode:   focusNode,
          decoration: InputDecoration(
            labelText:  widget.label,
            hintText:   'Tapez pour filtrer…',
            border:     OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled:     true,
            fillColor:  AppColors.card,
            prefixIcon: _selection != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: _BadgeType(_selection!.type),
                  )
                : const Icon(Icons.search_rounded, size: 18, color: AppColors.text2),
            suffixIcon: ctrl.text.isNotEmpty
                ? IconButton(
                    icon:    const Icon(Icons.clear_rounded, size: 16),
                    tooltip: 'Effacer',
                    onPressed: () {
                      ctrl.clear();
                      setState(() => _selection = null);
                      widget.onSelected(null);
                    },
                  )
                : null,
          ),
        ),
        optionsViewBuilder: (ctx, onSelect, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            color: AppColors.card,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 400),
              child: ListView.separated(
                padding:     EdgeInsets.zero,
                shrinkWrap:  true,
                itemCount:   options.length,
                separatorBuilder: (_, a) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (_, i) {
                  final u = options.elementAt(i);
                  final label = widget.labelPourOption(u);
                  return InkWell(
                    onTap: () => onSelect(u),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(children: [
                        _BadgeType(u.type),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600,
                                      color: AppColors.text),
                                  overflow: TextOverflow.ellipsis),
                              if (u.code != null)
                                Text(u.code!,
                                    style: const TextStyle(
                                        fontSize: 10, color: AppColors.text2)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class _BadgeType extends StatelessWidget {
  const _BadgeType(this.type);
  final String type;

  @override
  Widget build(BuildContext context) {
    final couleur = _couleurTypeUnite(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color:        couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(_labelTypeUnite(type),
          style: TextStyle(
              fontSize: 8, fontWeight: FontWeight.w800, color: couleur)),
    );
  }
}

// ─── Widgets utilitaires ──────────────────────────────────────────────────────

class _UniteLectureSeule extends StatelessWidget {
  const _UniteLectureSeule({required this.nomUnite});
  final String nomUnite;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color:        AppColors.card,
          border:       Border.all(color: AppColors.border),
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
    this.maxLines    = 1,
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
          border:    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled:    true,
          fillColor: AppColors.card,
        ),
        validator: obligatoire
            ? (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null
            : null,
      );
}

class _ToggleExtraordinaire extends StatelessWidget {
  const _ToggleExtraordinaire({required this.valeur, required this.onChanged});
  final bool valeur;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color:        AppColors.card,
          border:       Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SwitchListTile(
          value:         valeur,
          onChanged:     onChanged,
          activeThumbColor:  AppColors.secondary,
          activeTrackColor:  AppColors.secondary.withValues(alpha: 0.3),
          title: const Text('Réunion extraordinaire',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: const Text('Convocation exceptionnelle hors calendrier habituel',
              style: TextStyle(fontSize: 11, color: AppColors.text2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        ),
      );
}

class _DropdownType extends StatelessWidget {
  const _DropdownType({required this.valeur, required this.onChanged});
  final String   valeur;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        // ignore: deprecated_member_use
        value:   valeur,
        decoration: InputDecoration(
          labelText: 'Type de réunion',
          border:    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled:    true,
          fillColor: AppColors.card,
        ),
        items: AppEnums.typesReunion
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
    required this.onTap,
  });
  final String       label;
  final String       valeur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color:        AppColors.card,
            border:       Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.text2)),
              Text(valeur,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.text)),
            ]),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.text2),
          ]),
        ),
      );
}