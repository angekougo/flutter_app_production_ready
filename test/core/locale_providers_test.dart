import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_production_ready/core/l10n/locale_providers.dart';
import 'package:flutter_app_production_ready/core/network/tmdb_interceptor.dart';
import 'package:flutter_app_production_ready/core/network/tmdb_locale.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('resolveAppLocale', () {
    test('le choix de l’utilisateur prime sur l’appareil', () {
      expect(
        resolveAppLocale(const Locale('en'), const [Locale('fr', 'FR')]),
        const Locale('en'),
      );
    });

    test('sans choix : première langue de l’appareil prise en charge', () {
      expect(
        resolveAppLocale(null, const [Locale('de'), Locale('fr', 'CI')]),
        const Locale('fr'),
      );
    });

    test('aucune langue prise en charge : repli sur l’anglais', () {
      expect(
        resolveAppLocale(null, const [Locale('de'), Locale('ja')]),
        const Locale('en'),
      );
    });
  });

  group('LocaleController', () {
    Future<ProviderContainer> container(Map<String, Object> stored) async {
      SharedPreferences.setMockInitialValues(stored);
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocalesProvider.overrideWithValue(const [Locale('fr')]),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('restaure la langue enregistrée', () async {
      final c = await container({LocaleController.storageKey: 'en'});
      expect(c.read(localeControllerProvider), const Locale('en'));
      expect(c.read(appLocaleProvider), const Locale('en'));
    });

    test('persiste le choix, puis revient à la langue de l’appareil', () async {
      final c = await container({});
      expect(c.read(appLocaleProvider), const Locale('fr'));

      await c
          .read(localeControllerProvider.notifier)
          .setLocale(const Locale('en'));
      final prefs = c.read(sharedPreferencesProvider);
      expect(prefs.getString(LocaleController.storageKey), 'en');
      expect(c.read(appLocaleProvider), const Locale('en'));
      expect(c.read(tmdbLocaleProvider), TmdbLocale.english);

      await c.read(localeControllerProvider.notifier).setLocale(null);
      expect(prefs.getString(LocaleController.storageKey), isNull);
      expect(c.read(appLocaleProvider), const Locale('fr'));
    });
  });

  test('TmdbInterceptor ajoute la langue sans écraser celle de la requête', () {
    final interceptor = TmdbInterceptor('token', language: 'en-US');
    final handler = _CapturingHandler();

    interceptor.onRequest(RequestOptions(path: '/movie/popular'), handler);
    expect(handler.options!.queryParameters['language'], 'en-US');
    expect(handler.options!.headers['Authorization'], 'Bearer token');

    interceptor.onRequest(
      RequestOptions(path: '/x', queryParameters: {'language': 'fr-FR'}),
      handler,
    );
    expect(handler.options!.queryParameters['language'], 'fr-FR');
  });
}

class _CapturingHandler extends RequestInterceptorHandler {
  RequestOptions? options;

  @override
  void next(RequestOptions requestOptions) => options = requestOptions;
}
