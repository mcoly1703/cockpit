import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/repositories/finances_repository.dart';

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

  String   _type      = AppEnums.transactionEntree;
  String?  _categorie;
  DateTime _date      = DateTime.now();

  List<String> get _categories => _type == AppEnums.transactionEntree
      ? AppCategories.entrees
      : AppCategories.depenses;

  @override
  void dispose() {
    _montantCtrl.dispose();
    _descriptionCtrl.dispose();
    _benefCtrl.dispose();
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

  void _valider() {
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

    // On retourne les params au parent (FinancesPage) plutôt que d'appeler
    // le notifier ici pour rester dans la Clean Architecture
    Navigator.of(context).pop(ParamsAjouterTransaction(
      type:            _type,
      categorie:       _categorie!,
      montant:         montant,
      dateTransaction: _date,
      uniteId:         '',   // sera rempli par le notifier via l'utilisateur connecté
      description:     _descriptionCtrl.text.trim().isEmpty
          ? null
          : _descriptionCtrl.text.trim(),
      beneficiaire:    _benefCtrl.text.trim().isEmpty
          ? null
          : _benefCtrl.text.trim(),
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