import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/widgets/app_shell.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/militants/presentation/pages/militants_page.dart';


/// Point d'entrée de l'application.
///
/// Ordre d'initialisation :
/// 1. WidgetsFlutterBinding  → nécessaire avant tout appel async dans main()
/// 2. Supabase.initialize    → connexion au backend
/// 3. ProviderScope          → active Riverpod pour toute l'arborescence
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr', null);

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: CockpitApp()));
}

class CockpitApp extends StatelessWidget {
  const CockpitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: _router,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

/// Routeur central de l'application.
///
/// La fonction [redirect] joue le rôle de garde d'authentification :
/// - Si pas de session et on va ailleurs que /login → rediriger vers /login
/// - Si session active et on va sur /login → rediriger vers /dashboard
/// - Sinon → laisser passer (return null)
///
/// Au fil du développement des modules, remplacer les placeholders
/// par les vraies pages (LoginPage, DashboardPage, etc.)
final _router = GoRouter(
  initialLocation: AppRoutes.landing,
  redirect: (context, state) {
    final session     = Supabase.instance.client.auth.currentSession;
    final estConnecte = session != null;
    final location    = state.matchedLocation;

    final versLanding = location == AppRoutes.landing;
    final versLogin   = location == AppRoutes.login;

    if (!estConnecte && !versLanding && !versLogin) return AppRoutes.landing;
    if (estConnecte && (versLanding || versLogin))  return AppRoutes.dashboard;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.landing,
      builder: (_, __) => const LandingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (_, __) => const DashboardPage(),
        ),
        GoRoute(
          path: AppRoutes.militants,
          builder: (_, __) => const MilitantsPage(),
        ),
        GoRoute(
          path: AppRoutes.finances,
          builder: (_, __) => const _PlaceholderPage(titre: 'Finances'),
        ),
        GoRoute(
          path: AppRoutes.prospects,
          builder: (_, __) => const _PlaceholderPage(titre: 'Prospects'),
        ),
        GoRoute(
          path: AppRoutes.modules,
          builder: (_, __) => const _PlaceholderPage(titre: 'Modules'),
        ),
      ],
    ),
  ],
);

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.titre});
  final String titre;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        titre,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}