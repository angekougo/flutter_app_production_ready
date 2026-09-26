import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/l10n/locale_providers.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app_production_ready/features/profile/presentation/widgets/language_picker.dart';
import 'package:flutter_app_production_ready/l10n/app_localizations.dart';
import 'package:flutter_app_production_ready/shared/extensions/l10n_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_app.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('changer de langue traduit l’interface et mémorise le choix', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocalesProvider.overrideWithValue(const [Locale('fr')]),
        ],
        // Même câblage que CinethequeApp : la langue vient du provider.
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            locale: ref.watch(appLocaleProvider),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: Builder(
                builder: (context) => Column(
                  children: [
                    Text(context.l10n.navHome),
                    TextButton(
                      onPressed: () => showLanguagePicker(context),
                      child: Text(context.l10n.profileLanguage),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Appareil en français, aucun choix : interface en français.
    expect(find.text('Accueil'), findsOneWidget);

    await tester.tap(find.text('Langue'));
    await tester.pumpAndSettle();
    expect(find.text('Langue de l’application'), findsOneWidget);
    expect(find.text('Langue de l’appareil'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Accueil'), findsNothing);
    expect(prefs.getString(LocaleController.storageKey), 'en');
  });

  testWidgets('connexion en anglais : textes et erreurs de saisie', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: testApp(const LoginPage(), locale: const Locale('en')),
      ),
    );

    expect(find.text('Welcome back.'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });
}
