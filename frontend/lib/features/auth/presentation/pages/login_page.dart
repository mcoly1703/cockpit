import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/widgets/cockpit_button.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).seConnecter(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final entite    = ref.watch(selectedEntiteProvider);
    final estMoncap = entite == AppEntites.moncap;

    final gradient = estMoncap ? AppColors.moncapGradient : AppColors.topbarGradient;
    final nom      = estMoncap ? AppStrings.moncapNom  : AppStrings.appName;
    final sousTitre = estMoncap ? AppStrings.moncapSub  : AppStrings.pastefsub;

    // Navigation automatique après connexion réussie
    ref.listen(authProvider, (_, next) {
      next.whenOrNull(
        connecte: (_) => context.go(AppRoutes.dashboard),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Bouton retour vers landing
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.go(AppRoutes.landing),
                    icon: const Icon(Icons.arrow_back, color: Colors.white70, size: 18),
                    label: const Text('Retour', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(height: 8),

                // Logo / titre selon entité
                Text(
                  nom,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                Text(
                  sousTitre,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                // Formulaire
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            AppStrings.connexion,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: AppStrings.email,
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                            v == null || !v.contains('@') ? 'Email invalide' : null,
                          ),
                          const SizedBox(height: 16),

                          // Mot de passe
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: AppStrings.motDePasse,
                              prefixIcon: Icon(Icons.lock_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                            v == null || v.length < 6 ? 'Mot de passe trop court' : null,
                          ),
                          const SizedBox(height: 24),

                          // Message d'erreur
                          authState.whenOrNull(
                            erreur: (failure) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                failure.when(
                                  serveur:     (msg) => msg,
                                  reseau:      ()    => AppStrings.erreurReseau,
                                  nonAutorise: ()    => 'Email ou mot de passe incorrect',
                                  nonTrouve:   ()    => 'Compte introuvable',
                                  validation:  (msg) => msg,
                                ),
                                style: const TextStyle(color: AppColors.secondary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ) ?? const SizedBox.shrink(),

                          // Bouton
                          CockpitButton(
                            label: AppStrings.seConnecter,
                            isLoading: authState is AuthChargement,
                            onPressed: _seConnecter,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
