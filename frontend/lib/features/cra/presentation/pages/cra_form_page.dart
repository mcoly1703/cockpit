import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/compte_rendu.dart';
import '../../domain/repositories/cra_repository.dart';

class CraFormPage extends ConsumerStatefulWidget {
  const CraFormPage({
    super.key,
    required this.uniteId,
    this.craExistant,
    required this.onSave,
  });
  final String       uniteId;
  final CompteRendu? craExistant;
  final Future<Either<Failure, dynamic>> Function(ParamsCreerCr) onSave;

  @override
  ConsumerState<CraFormPage> createState() => _CraFormPageState();
}

class _CraFormPageState extends ConsumerState<CraFormPage> {
  final _formKey    = GlobalKey<FormState>();
  final _descCtrl   = TextEditingController();
  final _diffCtrl   = TextEditingController();
  final _contactsCtrl     = TextEditingController(text: '0');
  final _evenementsCtrl   = TextEditingController(text: '0');
  final _presencesCtrl    = TextEditingController(text: '0');
  final _cotisationsCtrl  = TextEditingController(text: '0');

  int  _mois  = DateTime.now().month;
  int  _annee = DateTime.now().year;
  bool _enEnvoi = false;

  bool get _estEdition => widget.craExistant != null;

  @override
  void initState() {
    super.initState();
    final cr = widget.craExistant;
    if (cr != null) {
      _mois  = cr.mois;
      _annee = cr.annee;
      _descCtrl.text         = cr.descriptionActivites;
      _diffCtrl.text         = cr.difficultes ?? '';
      _contactsCtrl.text     = '${cr.nouveauxContacts}';
      _evenementsCtrl.text   = '${cr.evenementsTenus}';
      _presencesCtrl.text    = '${cr.presencesTotal}';
      _cotisationsCtrl.text  = '${cr.cotisationsCollectees}';
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _diffCtrl.dispose();
    _contactsCtrl.dispose();
    _evenementsCtrl.dispose();
    _presencesCtrl.dispose();
    _cotisationsCtrl.dispose();
    super.dispose();
  }

  String _getUniteId() {
    if (widget.uniteId.isNotEmpty) return widget.uniteId;
    final u = ref.read(authProvider).whenOrNull(connecte: (u) => u);
    return u?.uniteOrganisationnelleId ?? '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enEnvoi = true);

    final params = ParamsCreerCr(
      uniteId:               _getUniteId(),
      mois:                  _mois,
      annee:                 _annee,
      descriptionActivites:  _descCtrl.text.trim(),
      nouveauxContacts:      int.tryParse(_contactsCtrl.text) ?? 0,
      evenementsTenus:       int.tryParse(_evenementsCtrl.text) ?? 0,
      presencesTotal:        int.tryParse(_presencesCtrl.text) ?? 0,
      cotisationsCollectees: double.tryParse(_cotisationsCtrl.text) ?? 0,
      difficultes:           _diffCtrl.text.trim().isEmpty ? null : _diffCtrl.text.trim(),
    );

    final result = await widget.onSave(params);
    if (!mounted) return;
    setState(() => _enEnvoi = false);

    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(f.when(
          serveur: (m) => m, reseau: () => 'Erreur réseau',
          nonAutorise: () => 'Non autorisé', nonTrouve: () => 'Introuvable',
          validation: (m) => m,
        )),
      )),
      (_) => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moisItems = List.generate(12, (i) => i + 1).map((m) {
      final label = DateFormat('MMMM', 'fr').format(DateTime(2000, m));
      return DropdownMenuItem(value: m, child: Text(label[0].toUpperCase() + label.substring(1)));
    }).toList();

    final anneeItems = List.generate(5, (i) => DateTime.now().year - i).map((a) {
      return DropdownMenuItem(value: a, child: Text('$a'));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_estEdition ? 'Modifier le CR' : 'Nouveau CR'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─ Période ─
            _SectionTitre('Période'),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _mois,
                  decoration: const InputDecoration(
                    labelText: 'Mois',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: moisItems,
                  onChanged: _estEdition ? null : (v) => setState(() => _mois = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _annee,
                  decoration: const InputDecoration(
                    labelText: 'Année',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: anneeItems,
                  onChanged: _estEdition ? null : (v) => setState(() => _annee = v!),
                ),
              ),
            ]),

            const SizedBox(height: 20),
            _SectionTitre('Indicateurs terrain'),
            const SizedBox(height: 8),
            _ChampNumerique(
              ctrl:   _contactsCtrl,
              label:  'Nouveaux contacts',
              icone:  Icons.people_outline,
            ),
            const SizedBox(height: 12),
            _ChampNumerique(
              ctrl:   _evenementsCtrl,
              label:  'Événements organisés',
              icone:  Icons.event_outlined,
            ),
            const SizedBox(height: 12),
            _ChampNumerique(
              ctrl:   _presencesCtrl,
              label:  'Total présences enregistrées',
              icone:  Icons.how_to_reg_outlined,
            ),
            const SizedBox(height: 12),
            _ChampNumerique(
              ctrl:      _cotisationsCtrl,
              label:     'Cotisations collectées (€)',
              icone:     Icons.euro_outlined,
              estDecimal: true,
            ),

            const SizedBox(height: 20),
            _SectionTitre('Description des activités'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                hintText: 'Décrivez les activités réalisées ce mois…',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Description requise' : null,
            ),

            const SizedBox(height: 20),
            _SectionTitre('Difficultés rencontrées (optionnel)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _diffCtrl,
              decoration: const InputDecoration(
                hintText: 'Obstacles, besoins, points d\'attention…',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _enEnvoi ? null : _submit,
                child: _enEnvoi
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_estEdition ? 'Enregistrer les modifications' : 'Enregistrer le brouillon'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets helpers ──────────────────────────────────────────────────────────

class _SectionTitre extends StatelessWidget {
  const _SectionTitre(this.texte);
  final String texte;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Container(width: 4, height: 16, color: AppColors.primary,
              margin: const EdgeInsets.only(right: 8)),
          Text(texte,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                  color: AppColors.primary)),
        ]),
      );
}

class _ChampNumerique extends StatelessWidget {
  const _ChampNumerique({
    required this.ctrl,
    required this.label,
    required this.icone,
    this.estDecimal = false,
  });
  final TextEditingController ctrl;
  final String                label;
  final IconData              icone;
  final bool                  estDecimal;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: estDecimal),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icone, size: 20),
          border: const OutlineInputBorder(),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Requis';
          final n = estDecimal ? double.tryParse(v) : int.tryParse(v);
          if (n == null || n < 0) return 'Valeur invalide';
          return null;
        },
      );
}