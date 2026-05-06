/// Configuration globale de l'application.
///
/// Les valeurs sensibles (URLs, clés API) sont injectées au build via --dart-define.
/// Ne JAMAIS écrire une valeur réelle dans ce fichier — il est versionné sur Git.
///
/// Lancement en développement :
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=xxx \
///     --dart-define=APP_ENV=development
class AppConfig {
  static const String appName    = 'PASTEF France — Plateforme Militante';
  static const String appVersion = '1.0.0';

  static const String supabaseUrl     = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String appUrl          = String.fromEnvironment('APP_URL', defaultValue: 'http://localhost:3000');
  static const String appEnv          = String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction  => appEnv == 'production';
}