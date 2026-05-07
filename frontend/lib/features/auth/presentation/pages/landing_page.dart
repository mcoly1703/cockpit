import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_tables.dart';
import '../providers/auth_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  String? _entiteSelectionnee;

  void _selectionner(String entite) {
    setState(() => _entiteSelectionnee = entite);
  }

  void _continuer() {
    if (_entiteSelectionnee == null) return;
    ref.read(selectedEntiteProvider.notifier).state = _entiteSelectionnee;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A1505), Color(0xFF1B4D1B), Color(0xFF8B0000)],
            stops: [0.0, 0.45, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Zone scrollable : drapeau + titre + cartes
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Column(
                    children: [
                      // Drapeau tricolore sénégalais
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _barreFlag(AppColors.primary),
                          const SizedBox(width: 6),
                          _barreFlag(const Color(0xFFFFD700)),
                          const SizedBox(width: 6),
                          _barreFlag(AppColors.secondary),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Titre principal
                      const Text(
                        'PASTEF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      const Text(
                        'Cockpit · Gestion & Pilotage',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Sous-titre
                      const Text(
                        AppStrings.choisirEntite,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Carte Pastef France
                      _EntiteCard(
                        entite:       AppEntites.pastef,
                        emoji:        '🌿',
                        nom:          AppStrings.appName,
                        description:  AppStrings.pastefsub,
                        couleur:      AppColors.primary,
                        selectionnee: _entiteSelectionnee == AppEntites.pastef,
                        onTap:        () => _selectionner(AppEntites.pastef),
                      ),

                      const SizedBox(height: 12),

                      // Carte MonCap Diaspora
                      _EntiteCard(
                        entite:       AppEntites.moncap,
                        emoji:        '🌍',
                        nom:          AppStrings.moncapNom,
                        description:  AppStrings.moncapSub,
                        couleur:      AppColors.moncapPrimary,
                        selectionnee: _entiteSelectionnee == AppEntites.moncap,
                        onTap:        () => _selectionner(AppEntites.moncap),
                      ),
                    ],
                  ),
                ),
              ),

              // Bouton ancré en bas, toujours visible
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _entiteSelectionnee != null ? _continuer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.white24,
                      disabledForegroundColor: Colors.white38,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      AppStrings.continuer,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barreFlag(Color couleur) {
    return Container(
      width: 16,
      height: 32,
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _EntiteCard extends StatelessWidget {
  const _EntiteCard({
    required this.entite,
    required this.emoji,
    required this.nom,
    required this.description,
    required this.couleur,
    required this.selectionnee,
    required this.onTap,
  });

  final String  entite;
  final String  emoji;
  final String  nom;
  final String  description;
  final Color   couleur;
  final bool    selectionnee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectionnee ? Colors.white : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectionnee ? couleur : Colors.white24,
            width: selectionnee ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selectionnee
                    ? couleur.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selectionnee ? couleur : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: selectionnee
                          ? Colors.black54
                          : Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            if (selectionnee)
              Icon(Icons.check_circle_rounded, color: couleur, size: 22),
          ],
        ),
      ),
    );
  }
}