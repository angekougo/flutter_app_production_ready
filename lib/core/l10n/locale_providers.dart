import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Langues proposées par l'application (la première sert de repli).
const supportedAppLocales = [Locale('en'), Locale('fr')];

/// Langue affichée : le choix de l'utilisateur s'il existe, sinon la
/// première langue de l'appareil prise en charge, sinon l'anglais.
Locale resolveAppLocale(Locale? preferred, List<Locale> deviceLocales) {
  bool supported(Locale l) =>
      supportedAppLocales.any((s) => s.languageCode == l.languageCode);

  if (preferred != null && supported(preferred)) {
    return Locale(preferred.languageCode);
  }
  for (final locale in deviceLocales) {
    if (supported(locale)) return Locale(locale.languageCode);
  }
  return supportedAppLocales.first;
}

/// Préférences clé/valeur, ouvertes dans `main` puis injectées par override.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Surcharger dans le ProviderScope.'),
);

/// Choix de langue de l'utilisateur, persisté ; `null` = langue de l'appareil.
class LocaleController extends Notifier<Locale?> {
  static const storageKey = 'app.locale';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Locale? build() {
    final code = _prefs.getString(storageKey);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs.remove(storageKey);
    } else {
      await _prefs.setString(storageKey, locale.languageCode);
    }
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

/// Langues de l'appareil, par ordre de préférence. Invalidé par l'application
/// quand l'utilisateur les change dans les réglages du système.
final deviceLocalesProvider = Provider<List<Locale>>(
  (ref) => PlatformDispatcher.instance.locales,
);

/// Langue effective de l'application (interface et contenus TMDB).
final appLocaleProvider = Provider<Locale>(
  (ref) => resolveAppLocale(
    ref.watch(localeControllerProvider),
    ref.watch(deviceLocalesProvider),
  ),
);
