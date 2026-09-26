import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/app/theme/app_theme.dart';
import 'package:flutter_app_production_ready/l10n/app_localizations.dart';

/// Langue par défaut des tests de widgets : les textes attendus sont en
/// français, comme dans le design.
const testLocale = Locale('fr');

/// [MaterialApp] minimale avec le thème et les traductions de l'application.
MaterialApp testApp(Widget home, {Locale locale = testLocale}) => MaterialApp(
  theme: AppTheme.dark,
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: home,
);

/// Variante GoRouter de [testApp].
MaterialApp testRouterApp(
  RouterConfig<Object> router, {
  Locale locale = testLocale,
}) => MaterialApp.router(
  theme: AppTheme.dark,
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  routerConfig: router,
);
