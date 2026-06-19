import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/repositories/militants_repository.dart';
import '../providers/militants_provider.dart';

class MilitantFormPage extends ConsumerStatefulWidget {
  const MilitantFormPage({
    super.key,
    this.militant,
    required this.unites,
    this.militants = const [],
  });

  final Militant? militant;
  final List<UniteOrganisationnelle> unites;
  final List<Militant> militants;

  @override
  ConsumerState<MilitantFormPage> createState() => _MilitantFormPageState();
}

class _MilitantFormPageState extends ConsumerState<MilitantFormPage> {
  final _formKey    = GlobalKey<FormState>();
  bool  _saving     = false;

  // Contrôleurs texte
  late final TextEditingController _nomCtrl;
  late final TextEditingController _prenomCtrl;
  late final TextEditingController _telCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _villeCtrl;
  late final TextEditingController _cpCtrl;

  // Valeurs choisies
  DateTime? _dateNaissance;
  DateTime  _dateAdhesion = DateTime.now();
  String?   _sexe;
  String?   _uniteId;
  String?   _parrainId;

  bool get _estModification => widget.militant != null;

  @override
  void initState() {
    super.initState();
    final m = widget.militant;
    _nomCtrl    = TextEditingController(text: m?.nom ?? '');
    _prenomCtrl = TextEditingController(text: m?.prenom ?? '');
    _telCtrl    = TextEditingController(text: m?.telephone ?? '');
    _emailCtrl  = TextEditingController(text: m?.email ?? '');
    _villeCtrl  = TextEditingController(text: m?.ville ?? '');
    _cpCtrl     = TextEditingController(text: m?.codePostal ?? '');
    _dateNaissance = m?.dateNaissance;
    _dateAdhesion  = m?.dateAdhesion ?? DateTime.now();
    _sexe          = m?.sexe;
    _uniteId       = m?.uniteId;
    _parrainId     = m?.parrainId;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _villeCtrl.dispose();
    _cpCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate({
    required DateTime? valeur,
    required DateTime premiere,
    required DateTime derniere,
    required void Function(DateTime) onChoisie,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: valeur ?? premiere,
      firstDate: premiere,
      lastDate: derniere,
      locale: const Locale('fr'),
    );
    if (date != null) setState(() => onChoisie(date));
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uniteId == null) {
      _showSnack('Veuillez sélectionner une unité', isError: true);
      return;
    }

    setState(() => _saving = true);
    final notifier = ref.read(militantsProvider.notifier);

    final result = _estModification
        ? await notifier.modifierMilitant(ParamsModifierMilitant(
            id:            widget.militant!.id,
            nom:           _nomCtrl.text.trim(),
            prenom:        _prenomCtrl.text.trim(),
            telephone:     _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
            email:         _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
            dateNaissance: _dateNaissance,
            sexe:          _sexe,
            ville:         _villeCtrl.text.trim().isEmpty ? null : _villeCtrl.text.trim(),
            codePostal:    _cpCtrl.text.trim().isEmpty ? null : _cpCtrl.text.trim(),
            uniteId:       _uniteId!,
            dateAdhesion:  _dateAdhesion,
            parrainId:     _parrainId,
          ))
        : await notifier.ajouterMilitant(ParamsAjouterMilitant(
            nom:           _nomCtrl.text.trim(),
            prenom:        _prenomCtrl.text.trim(),
            telephone:     _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
            email:         _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
            dateNaissance: _dateNaissance,
            sexe:          _sexe,
            ville:         _villeCtrl.text.trim().isEmpty ? null : _villeCtrl.text.trim(),
            codePostal:    _cpCtrl.text.trim().isEmpty ? null : _cpCtrl.text.trim(),
            uniteId:       _uniteId!,
            dateAdhesion:  _dateAdhesion,
            parrainId:     _parrainId,
          ));

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (f) => _showSnack(f.when(
        serveur:     (m) => 'Erreur : $m',
        reseau:      () => 'Pas de connexion réseau',
        nonAutorise: () => 'Accès non autorisé',
        nonTrouve:   () => 'Militant introuvable',
        validation:  (m) => m,
      ), isError: true),
      (_) {
        _showSnack(_estModification ? 'Militant modifié' : 'Militant ajouté');
        Navigator.of(context).pop();
      },
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.secondary : AppColors.primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final titre = _estModification
        ? 'Modifier ${widget.militant!.nom}'
        : 'Nouveau militant';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(titre, style: const TextStyle(fontSize: 16)),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            _Section(titre: 'Identité'),
            _Champ(
              ctrl: _nomCtrl,
              label: 'Nom *',
              icone: Icons.person,
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _prenomCtrl,
              label: 'Prénom *',
              icone: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Prénom requis' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Date de naissance',
                    valeur: _dateNaissance,
                    onTap: () => _choisirDate(
                      valeur:  _dateNaissance,
                      premiere: AppConstants.premiereDateNaissance,
                      derniere: DateTime.now(),
                      onChoisie: (d) => _dateNaissance = d,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sexe,
                    decoration: _inputDecoration('Sexe', Icons.wc),
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('Masculin')),
                      DropdownMenuItem(value: 'F', child: Text('Féminin')),
                    ],
                    onChanged: (v) => setState(() => _sexe = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Section(titre: 'Contact'),
            _Champ(
              ctrl: _telCtrl,
              label: 'Téléphone',
              icone: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _emailCtrl,
              label: 'Email',
              icone: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _Champ(ctrl: _villeCtrl, label: 'Ville', icone: Icons.location_city),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _Champ(ctrl: _cpCtrl, label: 'Code postal', icone: Icons.markunread_mailbox_outlined, keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Section(titre: 'Engagement'),
            DropdownButtonFormField<String>(
              initialValue: _uniteId,
              decoration: _inputDecoration('Unité *', Icons.account_tree_outlined),
              isExpanded: true,
              items: widget.unites.map((u) => DropdownMenuItem(
                value: u.id,
                child: Text(u.nom, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
              )).toList(),
              onChanged: (v) => setState(() => _uniteId = v),
              validator: (v) => v == null ? 'Unité requise' : null,
            ),
            const SizedBox(height: 12),
            _DateField(
              label: "Date d'adhésion *",
              valeur: _dateAdhesion,
              onTap: () => _choisirDate(
                valeur:   _dateAdhesion,
                premiere: AppConstants.premiereAdhesion,
                derniere: DateTime.now(),
                onChoisie: (d) => _dateAdhesion = d,
              ),
            ),
            const SizedBox(height: 12),
            _ParrainField(
              parrainId: _parrainId,
              militants: widget.militants,
              militantActuelId: widget.militant?.id,
              onChanged: (id) => setState(() => _parrainId = id),
            ),
            if (_estModification) ...[
              const SizedBox(height: 20),
              _Section(titre: 'Statut'),
              _StatutSelector(
                statut:   widget.militant!.statut,
                onChanged: (s) async {
                  final res = await ref
                      .read(militantsProvider.notifier)
                      .toggleStatut(widget.militant!.id, s);
                  if (!mounted) return;
                  res.fold(
                    (f) => _showSnack('Erreur', isError: true),
                    (_) {
                      _showSnack('Statut mis à jour');
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _BarreEnregistrement(
        saving: _saving,
        onEnregistrer: _enregistrer,
      ),
    );
  }
}

// ─── Widgets helpers ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.titre});
  final String titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        titre.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.text2,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label, IconData icone) =>
    InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, size: 18, color: AppColors.text2),
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

class _Champ extends StatelessWidget {
  const _Champ({
    required this.ctrl,
    required this.label,
    required this.icone,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  final TextEditingController ctrl;
  final String label;
  final IconData icone;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        decoration: _inputDecoration(label, icone),
      );
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.valeur, required this.onTap});
  final String label;
  final DateTime? valeur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(label, Icons.calendar_today_outlined),
        child: Text(
          valeur != null ? DateFormat('dd/MM/yyyy').format(valeur!) : '—',
          style: TextStyle(
              fontSize: 14,
              color: valeur != null ? AppColors.text : AppColors.text2),
        ),
      ),
    );
  }
}

class _StatutSelector extends StatelessWidget {
  const _StatutSelector({required this.statut, required this.onChanged});
  final String statut;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BoutonStatut(
          label: 'Actif',
          couleur: AppColors.primary,
          actif: statut == AppEnums.militantActif,
          onTap: () => onChanged(AppEnums.militantActif),
        ),
        const SizedBox(width: 8),
        _BoutonStatut(
          label: 'Inactif',
          couleur: AppColors.text2,
          actif: statut == AppEnums.militantInactif,
          onTap: () => onChanged(AppEnums.militantInactif),
        ),
        const SizedBox(width: 8),
        _BoutonStatut(
          label: 'Suspendu',
          couleur: AppColors.secondary,
          actif: statut == AppEnums.militantSuspendu,
          onTap: () => onChanged(AppEnums.militantSuspendu),
        ),
      ],
    );
  }
}

class _BoutonStatut extends StatelessWidget {
  const _BoutonStatut({
    required this.label,
    required this.couleur,
    required this.actif,
    required this.onTap,
  });
  final String label;
  final Color couleur;
  final bool actif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: actif ? couleur : AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: actif ? couleur : AppColors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: actif ? Colors.white : AppColors.text2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ParrainField extends StatefulWidget {
  const _ParrainField({
    required this.parrainId,
    required this.militants,
    this.militantActuelId,
    required this.onChanged,
  });
  final String? parrainId;
  final List<Militant> militants;
  final String? militantActuelId;
  final void Function(String?) onChanged;

  @override
  State<_ParrainField> createState() => _ParrainFieldState();
}

class _ParrainFieldState extends State<_ParrainField> {
  final _ctrl = TextEditingController();
  List<Militant> _suggestions = [];
  bool _showSuggestions = false;

  String? _nomParrain() {
    if (widget.parrainId == null) return null;
    final p = widget.militants.where((m) => m.id == widget.parrainId).firstOrNull;
    return p != null ? '${p.prenom} ${p.nom}' : null;
  }

  void _rechercher(String query) {
    if (query.length < 2) {
      setState(() { _suggestions = []; _showSuggestions = false; });
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _suggestions = widget.militants
          .where((m) =>
              m.id != widget.militantActuelId &&
              ('${m.nom} ${m.prenom}'.toLowerCase().contains(q) ||
               '${m.prenom} ${m.nom}'.toLowerCase().contains(q)))
          .take(8)
          .toList();
      _showSuggestions = _suggestions.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nom = _nomParrain();

    if (nom != null && _ctrl.text.isEmpty) {
      _ctrl.text = nom;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _ctrl,
          onChanged: (v) {
            if (widget.parrainId != null && v != nom) {
              widget.onChanged(null);
            }
            _rechercher(v);
          },
          decoration: InputDecoration(
            labelText: 'Parrainé par (optionnel)',
            hintText: 'Rechercher un militant…',
            prefixIcon: const Icon(Icons.person_search_outlined, size: 18, color: AppColors.text2),
            suffixIcon: widget.parrainId != null
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _ctrl.clear();
                      widget.onChanged(null);
                      setState(() { _suggestions = []; _showSuggestions = false; });
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: widget.parrainId != null ? AppColors.primary : AppColors.border)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 2),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (_, i) {
                final m = _suggestions[i];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      '${m.prenom.isNotEmpty ? m.prenom[0] : ''}${m.nom.isNotEmpty ? m.nom[0] : ''}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ),
                  title: Text('${m.prenom} ${m.nom}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(m.ville ?? '', style: const TextStyle(fontSize: 11)),
                  onTap: () {
                    _ctrl.text = '${m.prenom} ${m.nom}';
                    widget.onChanged(m.id);
                    setState(() { _suggestions = []; _showSuggestions = false; });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _BarreEnregistrement extends StatelessWidget {
  const _BarreEnregistrement({required this.saving, required this.onEnregistrer});
  final bool saving;
  final VoidCallback onEnregistrer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16,
          12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: saving ? null : onEnregistrer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Enregistrer',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ),
      ),
    );
  }
}