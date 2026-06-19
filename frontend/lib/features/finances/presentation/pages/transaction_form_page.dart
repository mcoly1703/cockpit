import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/donateur.dart';
import '../../domain/repositories/finances_repository.dart';
import '../providers/finances_provider.dart';

class TransactionFormPage extends ConsumerStatefulWidget {
  const TransactionFormPage({super.key});

  @override
  ConsumerState<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _montantCtrl     = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _benefCtrl       = TextEditingController();

  // Donateur externe
  final _donNomCtrl      = TextEditingController();
  final _donPrenomCtrl   = TextEditingController();
  final _donTelCtrl      = TextEditingController();
  final _donEmailCtrl    = TextEditingController();
  final _donVilleCtrl    = TextEditingController();

  String   _type      = AppEnums.transactionEntree;
  String?  _categorie;
  DateTime _date      = DateTime.now();
  String?  _donateurId;
  String   _typeDonateur = 'aucun'; // 'aucun' | 'militant' | 'externe'
  String?  _militantDonateurId;

  List<String> get _categories => _type == AppEnums.transactionEntree
      ? AppCategories.entrees
      : AppCategories.depenses;

  bool get _estDon => _categorie == AppCategories.don;

  @override
  void dispose() {
    _montantCtrl.dispose();
    _descriptionCtrl.dispose();
    _benefCtrl.dispose();
    _donNomCtrl.dispose();
    _donPrenomCtrl.dispose();
    _donTelCtrl.dispose();
    _donEmailCtrl.dispose();
    _donVilleCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: AppConstants.premiereAdhesion,
      lastDate: DateTime.now(),
      locale: const Locale('fr'),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _valider() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categorie == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez choisir une catégorie'),
        backgroundColor: AppColors.secondary,
      ));
      return;
    }

    final montant = double.tryParse(
        _montantCtrl.text.trim().replaceAll(',', '.'));
    if (montant == null || montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Montant invalide'),
        backgroundColor: AppColors.secondary,
      ));
      return;
    }

    String? donateurId = _donateurId;
    String? militantId = _militantDonateurId;

    if (_estDon && _typeDonateur == 'externe' && donateurId == null) {
      if (_donNomCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nom du donateur requis'),
          backgroundColor: AppColors.secondary,
        ));
        return;
      }
      final result = await ref.read(financesProvider.notifier).creerDonateur(
        ParamsCreerDonateur(
          nom:       _donNomCtrl.text.trim(),
          prenom:    _donPrenomCtrl.text.trim().isEmpty ? null : _donPrenomCtrl.text.trim(),
          telephone: _donTelCtrl.text.trim().isEmpty ? null : _donTelCtrl.text.trim(),
          email:     _donEmailCtrl.text.trim().isEmpty ? null : _donEmailCtrl.text.trim(),
          ville:     _donVilleCtrl.text.trim().isEmpty ? null : _donVilleCtrl.text.trim(),
        ),
      );
      if (!mounted) return;
      if (result.isLeft()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erreur lors de la création du donateur'),
          backgroundColor: AppColors.secondary,
        ));
        return;
      }
      donateurId = result.getOrElse(() => throw StateError('unreachable')).id;
    }

    if (!mounted) return;
    Navigator.of(context).pop(ParamsAjouterTransaction(
      type:            _type,
      categorie:       _categorie!,
      montant:         montant,
      dateTransaction: _date,
      uniteId:         '',
      description:     _descriptionCtrl.text.trim().isEmpty
          ? null
          : _descriptionCtrl.text.trim(),
      beneficiaire:    _benefCtrl.text.trim().isEmpty
          ? null
          : _benefCtrl.text.trim(),
      militantId:      militantId,
      donateurId:      donateurId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Nouvelle transaction', style: TextStyle(fontSize: 16)),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Type : Entrée / Dépense
            _Section(titre: 'TYPE'),
            Row(children: [
              Expanded(child: _BoutonType(
                label:   'Entrée',
                icone:   Icons.arrow_downward_rounded,
                actif:   _type == AppEnums.transactionEntree,
                couleur: AppColors.primary,
                onTap:   () => setState(() {
                  _type      = AppEnums.transactionEntree;
                  _categorie = null;
                }),
              )),
              const SizedBox(width: 10),
              Expanded(child: _BoutonType(
                label:   'Dépense',
                icone:   Icons.arrow_upward_rounded,
                actif:   _type == AppEnums.transactionDepense,
                couleur: AppColors.secondary,
                onTap:   () => setState(() {
                  _type      = AppEnums.transactionDepense;
                  _categorie = null;
                }),
              )),
            ]),

            const SizedBox(height: 20),
            _Section(titre: 'DÉTAILS'),

            // Montant
            TextFormField(
              controller:  _montantCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _deco('Montant (€) *', Icons.euro_rounded),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Montant requis' : null,
            ),
            const SizedBox(height: 12),

            // Catégorie
            DropdownButtonFormField<String>(
              value:       _categorie,
              decoration:  _deco('Catégorie *', Icons.category_outlined),
              isExpanded:  true,
              items: _categories.map((c) => DropdownMenuItem(
                value: c,
                child: Text(AppCategories.label(c), style: const TextStyle(fontSize: 13)),
              )).toList(),
              onChanged:   (v) => setState(() => _categorie = v),
              validator:   (v) => v == null ? 'Catégorie requise' : null,
            ),
            const SizedBox(height: 12),

            // Date
            InkWell(
              onTap: _choisirDate,
              child: InputDecorator(
                decoration: _deco('Date *', Icons.calendar_today_outlined),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_date),
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _Section(titre: 'INFORMATIONS OPTIONNELLES'),
            TextFormField(
              controller:  _descriptionCtrl,
              decoration:  _deco('Description', Icons.notes_rounded),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _benefCtrl,
              decoration: _deco('Bénéficiaire / Fournisseur', Icons.person_outline),
            ),

            if (_estDon) ...[
              const SizedBox(height: 20),
              _Section(titre: 'DONATEUR'),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  ChoiceChip(
                    label: Text('Aucun', style: TextStyle(fontSize: 11,
                        color: _typeDonateur == 'aucun' ? Colors.white : AppColors.text2)),
                    selected: _typeDonateur == 'aucun',
                    onSelected: (_) => setState(() { _typeDonateur = 'aucun'; _donateurId = null; _militantDonateurId = null; }),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.card,
                    side: BorderSide(color: _typeDonateur == 'aucun' ? AppColors.primary : AppColors.border),
                  ),
                  ChoiceChip(
                    label: Text('Militant', style: TextStyle(fontSize: 11,
                        color: _typeDonateur == 'militant' ? Colors.white : AppColors.text2)),
                    selected: _typeDonateur == 'militant',
                    onSelected: (_) => setState(() { _typeDonateur = 'militant'; _donateurId = null; }),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.card,
                    side: BorderSide(color: _typeDonateur == 'militant' ? AppColors.primary : AppColors.border),
                  ),
                  ChoiceChip(
                    label: Text('Externe', style: TextStyle(fontSize: 11,
                        color: _typeDonateur == 'externe' ? Colors.white : AppColors.text2)),
                    selected: _typeDonateur == 'externe',
                    onSelected: (_) => setState(() { _typeDonateur = 'externe'; _militantDonateurId = null; }),
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.card,
                    side: BorderSide(color: _typeDonateur == 'externe' ? AppColors.accent : AppColors.border),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_typeDonateur == 'externe') ...[
                _DonateurExterneForm(
                  nomCtrl: _donNomCtrl,
                  prenomCtrl: _donPrenomCtrl,
                  telCtrl: _donTelCtrl,
                  emailCtrl: _donEmailCtrl,
                  villeCtrl: _donVilleCtrl,
                  donateurId: _donateurId,
                  onDonateurSelectionne: (d) => setState(() {
                    _donateurId = d.id;
                    _donNomCtrl.text = d.nom;
                    _donPrenomCtrl.text = d.prenom ?? '';
                    _donTelCtrl.text = d.telephone ?? '';
                    _donEmailCtrl.text = d.email ?? '';
                    _donVilleCtrl.text = d.ville ?? '';
                  }),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: _BarreSave(onEnregistrer: _valider),
    );
  }
}

// ─── Widgets helpers ──────────────────────────────────────────────────────────

InputDecoration _deco(String label, IconData icone) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, size: 18, color: AppColors.text2),
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

class _Section extends StatelessWidget {
  const _Section({required this.titre});
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(titre,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                color: AppColors.text2, letterSpacing: 1)),
      );
}

class _BoutonType extends StatelessWidget {
  const _BoutonType({
    required this.label,
    required this.icone,
    required this.actif,
    required this.couleur,
    required this.onTap,
  });
  final String   label;
  final IconData icone;
  final bool     actif;
  final Color    couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: actif ? couleur : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: actif ? couleur : AppColors.border, width: 1.5),
          ),
          child: Column(children: [
            Icon(icone, color: actif ? Colors.white : AppColors.text2, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: actif ? Colors.white : AppColors.text2)),
          ]),
        ),
      );
}

class _DonateurExterneForm extends ConsumerStatefulWidget {
  const _DonateurExterneForm({
    required this.nomCtrl,
    required this.prenomCtrl,
    required this.telCtrl,
    required this.emailCtrl,
    required this.villeCtrl,
    required this.donateurId,
    required this.onDonateurSelectionne,
  });
  final TextEditingController nomCtrl;
  final TextEditingController prenomCtrl;
  final TextEditingController telCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController villeCtrl;
  final String? donateurId;
  final void Function(Donateur) onDonateurSelectionne;

  @override
  ConsumerState<_DonateurExterneForm> createState() =>
      _DonateurExterneFormState();
}

class _DonateurExterneFormState extends ConsumerState<_DonateurExterneForm> {
  List<Donateur> _suggestions = [];

  void _rechercherDonateur(String query) {
    if (query.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    final donateurs = ref.read(donateursProvider).valueOrNull ?? [];
    final q = query.toLowerCase();
    setState(() {
      _suggestions = donateurs
          .where((d) =>
              d.nom.toLowerCase().contains(q) ||
              (d.prenom?.toLowerCase().contains(q) ?? false) ||
              (d.telephone?.contains(q) ?? false))
          .take(5)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.nomCtrl,
          onChanged: _rechercherDonateur,
          decoration: _deco('Nom du donateur *', Icons.person_outline),
        ),
        if (_suggestions.isNotEmpty && widget.donateurId == null)
          Container(
            margin: const EdgeInsets.only(top: 2, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                  child: Text('Donateurs existants',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text2)),
                ),
                ..._suggestions.map((d) => ListTile(
                      dense: true,
                      title: Text(
                          '${d.prenom ?? ''} ${d.nom}'.trim(),
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text(d.telephone ?? '',
                          style: const TextStyle(fontSize: 11)),
                      onTap: () {
                        widget.onDonateurSelectionne(d);
                        setState(() => _suggestions = []);
                      },
                    )),
              ],
            ),
          ),
        if (widget.donateurId != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                const Text('Donateur existant sélectionné',
                    style: TextStyle(fontSize: 11, color: AppColors.primary)),
              ]),
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.prenomCtrl,
          decoration: _deco('Prénom', Icons.person_outline),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.telCtrl,
          keyboardType: TextInputType.phone,
          decoration: _deco('Téléphone', Icons.phone_outlined),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: _deco('Email', Icons.email_outlined),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.villeCtrl,
          decoration: _deco('Ville', Icons.location_city_outlined),
        ),
      ],
    );
  }
}

class _BarreSave extends StatelessWidget {
  const _BarreSave({required this.onEnregistrer});
  final VoidCallback onEnregistrer;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onEnregistrer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Enregistrer',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
      );
}