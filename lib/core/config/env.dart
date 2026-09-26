import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Accès typé aux variables d'environnement définies dans `.env`.
///
/// Aucun secret n'est écrit dans le code source : tout provient du fichier
/// `.env` (ignoré par Git), dont `.env.example` décrit la structure.
abstract final class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get tmdbReadToken => _require('TMDB_READ_TOKEN');
  static String get supabaseUrl => _require('SUPABASE_URL');
  static String get supabasePublishableKey =>
      _require('SUPABASE_PUBLISHABLE_KEY');

  static String _require(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      throw StateError(
        'Variable "$key" manquante. Copiez .env.example en .env et renseignez-la.',
      );
    }
    return value;
  }
}
