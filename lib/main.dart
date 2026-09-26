import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/isar_schemas.dart';
import 'core/config/env.dart';
import 'core/storage/isar_service.dart';
import 'core/storage/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF131210),
    ),
  );

  await Env.load();

  // Restaure la session persistée (si elle existe) et programme le
  // rafraîchissement automatique du JWT avant son expiration.
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SecureSessionStorage(),
      autoRefreshToken: true,
    ),
  );

  // Base locale : cache TMDB + favoris, disponibles hors connexion.
  final isar = await IsarService.open(isarSchemas);

  runApp(
    ProviderScope(
      // Pas de relance automatique des providers en erreur (Riverpod 3) :
      // l'utilisateur réessaie, ou le retour du réseau déclenche le rechargement.
      retry: (retryCount, error) => null,
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const CinethequeApp(),
    ),
  );
}
