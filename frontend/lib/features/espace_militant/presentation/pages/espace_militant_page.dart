import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/espace_militant_provider.dart';
import '../widgets/cotisation_mois_grid.dart';
import '../widgets/finances_resume_card.dart';

class EspaceMilitantPage extends ConsumerStatefulWidget {
  const EspaceMilitantPage({super.key, required this.numeroCarte});
  final String numeroCarte;

  @override
  ConsumerState<EspaceMilitantPage> createState() =>
      _EspaceMilitantPageState();
}

class _EspaceMilitantPageState extends ConsumerState<EspaceMilitantPage> {
  final _telCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _telCtrl.dispose();
    super.dispose();
  }

  void _verifier() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(espaceMilitantProvider.notifier).verifier(
          widget.numeroCarte,
          _telCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(espaceMilitantProvider);
    final annee = DateTime.now().year;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.topbarGradient),
        child: SafeArea(
          child: state.when(
            verification: () => _FormVerification(
              formKey: _formKey,
              telCtrl: _telCtrl,
              numeroCarte: widget.numeroCarte,
              onVerifier: _verifier,
            ),
            chargement: () => const Center(
                child:
                    CircularProgressIndicator(color: Colors.white)),
            erreur: (msg) => _FormVerification(
              formKey: _formKey,
              telCtrl: _telCtrl,
              numeroCarte: widget.numeroCarte,
              onVerifier: _verifier,
              erreur: msg,
            ),
            charge: (militant, cotisations, finances) =>
                SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête
                  const Text('Mon Espace Militant',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                  const SizedBox(height: 16),

                  // Carte profil
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          '${militant.prenom.isNotEmpty ? militant.prenom[0] : ''}'
                          '${militant.nom.isNotEmpty ? militant.nom[0] : ''}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${militant.prenom} ${militant.nom}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.text)),
                              Text(militant.numeroCarte,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.text2)),
                              Text(
                                  'Membre depuis ${DateFormat('MMMM yyyy', 'fr').format(militant.dateAdhesion)}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.text2)),
                              Text(militant.uniteNom,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                            ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // Cotisations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                              'MES COTISATIONS $annee',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text2,
                                  letterSpacing: 0.8)),
                          const SizedBox(height: 12),
                          CotisationMoisGrid(
                              cotisations: cotisations),
                        ]),
                  ),
                  const SizedBox(height: 16),

                  // Finances cellule + SS
                  Row(children: [
                    Expanded(
                      child: FinancesResumeCard(
                        titre: militant.uniteNom,
                        solde: finances.celluleSolde,
                        nbMembres: finances.celluleNbMembres,
                        couleur: AppColors.primary,
                        icone: Icons.location_city_outlined,
                      ),
                    ),
                    if (finances.sousSectionNom != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: FinancesResumeCard(
                          titre: finances.sousSectionNom!,
                          solde: finances.sousSectionSolde ?? 0,
                          nbMembres:
                              finances.sousSectionNbMembres ?? 0,
                          couleur: AppColors.secondary,
                          icone: Icons.account_tree_outlined,
                        ),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormVerification extends StatelessWidget {
  const _FormVerification({
    required this.formKey,
    required this.telCtrl,
    required this.numeroCarte,
    required this.onVerifier,
    this.erreur,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController telCtrl;
  final String numeroCarte;
  final VoidCallback onVerifier;
  final String? erreur;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Text('PASTEF',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3)),
          const SizedBox(height: 4),
          const Text('Mon Espace Militant',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 32),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Carte : $numeroCarte',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: telCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Votre téléphone',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Téléphone requis'
                            : null,
                      ),
                      if (erreur != null) ...[
                        const SizedBox(height: 12),
                        Text(erreur!,
                            style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13),
                            textAlign: TextAlign.center),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onVerifier,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          child: const Text('Accéder à mon espace',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
