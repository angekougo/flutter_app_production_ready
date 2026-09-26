import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../network/api_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/tmdb_interceptor.dart';

/// Client Dio dédié à TMDB.
final tmdbDioProvider = Provider<Dio>(
  (ref) => DioClient.create(
    baseUrl: ApiConstants.tmdbBaseUrl,
    interceptors: [TmdbInterceptor(Env.tmdbReadToken)],
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
