import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/repositories/prospects_repository.dart';

const _mouvements = ['JPS', 'MOJIP', 'Cadres', 'Foyers', 'Maggi Pastef'];

class ProspectFormPage extends ConsumerStatefulWidget {
  const ProspectFormPage({super.key});

  @override
  ConsumerState<ProspectFormPage> createState() => _ProspectFormPageState();
}

class _ProspectFormPageState extends ConsumerState<ProspectFormPage> {
  final _formKey   = GlobalKey<FormState>();
  final _nomCtrl   = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telCtrl   = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _sexe;
  String? _mouvementInteret;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _villeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;

    final utilisateur = ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) return;

    Navigator.of(context).pop(
      ParamsAjouterProspect(
        nom:             _nomCtrl.text.trim(),
        prenom:          _prenomCtrl.text.trim(),
        telephone:       _telCtrl.text.trim(),
        email:           _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        ville:           _villeCtrl.text.trim(),
        sexe:            _sexe,
        mouvementInteret: _mouvementInteret,
        notes:           _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        uniteId:         utilisateur.uniteOrganisationnelleId ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nouveau prospect'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(titre: 'Identité'),
            _Champ(
              ctrl: _nomCtrl,
              label: 'Nom',
              obligatoire: true,
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _prenomCtrl,
              label: 'Prénom',
              obligatoire: true,
            ),
            const SizedBox(height: 12),
            _DropdownSexe(
              valeur: _sexe,
              onChanged: (v) => setState(() => _sexe = v),
            ),
            const SizedBox(height: 20),
            _Section(titre: 'Contact'),
            _Champ(
              ctrl: _telCtrl,
              label: 'Téléphone',
              type: TextInputType.phone,
              obligatoire: true,
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _emailCtrl,
              label: 'Email (optionnel)',
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _villeCtrl,
              label: 'Ville',
              obligatoire: true,
            ),
            const SizedBox(height: 20),
            _Section(titre: 'Intérêt'),
            _DropdownMouvement(
              valeur: _mouvementInteret,
              onChanged: (v) => setState(() => _mouvementInteret = v),
            ),
            const SizedBox(height: 12),
            _Champ(
              ctrl: _notesCtrl,
              label: 'Notes (optionnel)',
              maxLines: 3,
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
                child: const Text('Enregistrer le prospect',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets internes ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.titre});
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          titre.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.text2,
            letterSpacing: 0.8,
          ),
        ),
      );
}

class _Champ extends StatelessWidget {
  const _Champ({
    required this.ctrl,
    required this.label,
    this.type = TextInputType.text,
    this.obligatoire = false,
    this.maxLines = 1,
  });
  final TextEditingController ctrl;
  final String              label;
  final TextInputType       type;
  final bool                obligatoire;
  final int                 maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        keyboardType: type,
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

class _DropdownSexe extends StatelessWidget {
  const _DropdownSexe({required this.valeur, required this.onChanged});
  final String? valeur;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        // ignore: deprecated_member_use
        value: valeur,
        decoration: InputDecoration(
          labelText: 'Sexe (optionnel)',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
        ),
        items: const [
          DropdownMenuItem(value: AppEnums.sexeHomme,  child: Text('Homme')),
          DropdownMenuItem(value: AppEnums.sexeFemme,  child: Text('Femme')),
          DropdownMenuItem(value: AppEnums.sexeAutre,  child: Text('Autre')),
        ],
        onChanged: onChanged,
      );
}

class _DropdownMouvement extends StatelessWidget {
  const _DropdownMouvement({required this.valeur, required this.onChanged});
  final String? valeur;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        // ignore: deprecated_member_use
        value: valeur,
        decoration: InputDecoration(
          labelText: 'Mouvement d\'intérêt (optionnel)',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.card,
        ),
        items: _mouvements
            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
            .toList(),
        onChanged: onChanged,
      );
}