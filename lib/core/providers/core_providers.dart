import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../l10n/locale_providers.dart';
import '../network/api_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/tmdb_interceptor.dart';
import '../network/tmdb_locale.dart';

/// Langue/région TMDB. Un changement de langue recrée le client TMDB, donc
/// les repositories et les listes qui en dépendent : les contenus sont
/// rechargés dans la nouvelle langue.
final tmdbLocaleProvider = Provider<TmdbLocale>(
  (ref) => TmdbLocale.fromLocale(ref.watch(appLocaleProvider)),
);

/// Client Dio dédié à TMDB.
final tmdbDioProvider = Provider<Dio>(
  (ref) => DioClient.create(
    baseUrl: ApiConstants.tmdbBaseUrl,
    interceptors: [
      TmdbInterceptor(
        Env.tmdbReadToken,
        language: ref.watch(tmdbLocaleProvider).language,
      ),
    ],
  ),
);

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(Connectivity()),
);

/// `true` si une interface réseau est active ; alimente la bannière hors ligne.
final networkStatusProvider = StreamProvider<bool>((ref) async* {
  final info = ref.watch(networkInfoProvider);
  yield await info.isConnected;
  yield* info.onStatusChange;
});
