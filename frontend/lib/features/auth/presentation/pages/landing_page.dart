import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
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

                      const SizedBox(height: 24),

                      const Text(
                        'PASTEF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
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

                      const SizedBox(height: 16),

                      const Text(
                        AppStrings.pastefsub,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Bouton connexion ancré en bas
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Se connecter',
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

  Widget _barreFlag(Color couleur) => Container(
        width: 16,
        height: 32,
        decoration: BoxDecoration(
          color: couleur,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}