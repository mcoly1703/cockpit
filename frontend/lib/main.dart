import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'features/finances/presentation/pages/finances_page.dart';
import 'features/militants/presentation/pages/militants_page.dart';
import 'features/evenements/presentation/pages/evenements_page.dart';
import 'features/prospects/presentation/pages/prospects_page.dart';
import 'features/reunions/presentation/pages/reunions_page.dart';
import 'features/bureau/presentation/pages/bureau_page.dart';
import 'features/rapports/presentation/pages/rapports_page.dart';
import 'features/scan/presentation/pages/scan_page.dart';
import 'features/elections/presentation/pages/elections_page.dart';
import 'features/cra/presentation/pages/cra_page.dart';
import 'core/widgets/modules_page.dart';
import 'core/widgets/organigramme_page.dart';
import 'features/palmares/presentation/pages/palmares_page.dart';


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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
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

/// Notifie le routeur à chaque changement de session Supabase.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable() {
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}

final _authListenable = _AuthListenable();

/// Routeur central de l'application.
///
/// La fonction [redirect] joue le rôle de garde d'authentification :
/// - Si pas de session et on va ailleurs que /login → rediriger vers /login
/// - Si session active et on va sur /login → rediriger vers /dashboard
/// - Sinon → laisser passer (return null)
final _router = GoRouter(
  initialLocation: AppRoutes.landing,
  refreshListenable: _authListenable,
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
          builder: (_, __) => const FinancesPage(),
        ),
        GoRoute(
          path: AppRoutes.evenements,
          builder: (_, __) => const EvenementsPage(),
        ),
        GoRoute(
          path: AppRoutes.prospects,
          builder: (_, __) => const ProspectsPage(),
        ),
        GoRoute(
          path: AppRoutes.reunions,
          builder: (_, __) => const ReunionsPage(),
        ),
        GoRoute(
          path: AppRoutes.bureau,
          builder: (_, __) => const BureauPage(),
        ),
        GoRoute(
          path: AppRoutes.rapports,
          builder: (_, __) => const RapportsPage(),
        ),
        GoRoute(
          path: AppRoutes.scan,
          builder: (_, __) => const ScanPage(),
        ),
        GoRoute(
          path: AppRoutes.elections,
          builder: (_, __) => const ElectionsPage(),
        ),
        GoRoute(
          path: AppRoutes.cra,
          builder: (_, __) => const CraPage(),
        ),
        GoRoute(
          path: AppRoutes.modules,
          builder: (_, __) => const ModulesPage(),
        ),
        GoRoute(
          path: AppRoutes.organigramme,
          builder: (_, __) => const OrganigrammePage(),
        ),
        GoRoute(
          path: AppRoutes.palmares,
          builder: (_, __) => const PalmaresPage(),
        ),
      ],
    ),
  ],
);