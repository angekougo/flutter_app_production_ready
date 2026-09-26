import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/l10n/locale_providers.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CinethequeApp extends ConsumerStatefulWidget {
  const CinethequeApp({super.key});

  @override
  ConsumerState<CinethequeApp> createState() => _CinethequeAppState();
}

class _CinethequeAppState extends ConsumerState<CinethequeApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// L'utilisateur a changé la langue du système : si l'application suit
  /// la langue de l'appareil, l'interface et les contenus basculent.
  @override
  void didChangeLocales(List<Locale>? locales) =>
      ref.invalidate(deviceLocalesProvider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      locale: ref.watch(appLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
