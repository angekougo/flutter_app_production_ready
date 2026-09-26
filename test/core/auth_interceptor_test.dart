import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_app_production_ready/core/network/auth_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Faux jetons : « expired » → « fresh » au rafraîchissement.
class FakeTokens implements AuthTokenProvider {
  FakeTokens({this.token = 'expired', this.refreshed = 'fresh'});

  String? token;
  final String? refreshed;
  bool expired = false;
  int refreshCalls = 0;

  @override
  String? get accessToken => token;

  @override
  bool get isAccessTokenExpired => expired;

  @override
  Future<String?> refreshAccessToken() async {
    refreshCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    token = refreshed;
    expired = false;
    return refreshed;
  }
}

/// Faux serveur : 200 seulement avec « Bearer fresh », sinon 401.
class FakeServer implements HttpClientAdapter {
  final receivedTokens = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final auth = options.headers['Authorization'] as String?;
    receivedTokens.add(auth);
    final ok = auth == 'Bearer fresh';
    return ResponseBody.fromString(
      jsonEncode(ok ? {'email': 'awa@exemple.com'} : {'msg': 'JWT expired'}),
      ok ? 200 : 401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeServer server;
  late Dio dio;

  Dio buildDio(FakeTokens tokens) {
    final dio = Dio(BaseOptions(baseUrl: 'https://supabase.test'))
      ..httpClientAdapter = server;
    dio.interceptors.add(AuthInterceptor(tokens: tokens, dio: dio));
    return dio;
  }

  setUp(() => server = FakeServer());

  test('injecte le JWT courant dans l’en-tête Authorization', () async {
    dio = buildDio(FakeTokens(token: 'fresh'));

    final response = await dio.get<Map<String, dynamic>>('/auth/v1/user');

    expect(response.data!['email'], 'awa@exemple.com');
    expect(server.receivedTokens, ['Bearer fresh']);
  });

  test('401 → rafraîchit le jeton puis rejoue la requête', () async {
    final tokens = FakeTokens();
    dio = buildDio(tokens);

    final response = await dio.get<Map<String, dynamic>>('/auth/v1/user');

    expect(response.statusCode, 200);
    expect(tokens.refreshCalls, 1);
    expect(server.receivedTokens, ['Bearer expired', 'Bearer fresh']);
  });

  test(
    'JWT déjà expiré : rafraîchi avant l’envoi, sans passer par 401',
    () async {
      final tokens = FakeTokens()..expired = true;
      dio = buildDio(tokens);

      await dio.get<dynamic>('/auth/v1/user');

      expect(server.receivedTokens, ['Bearer fresh']);
    },
  );

  test('rafraîchissement impossible : la 401 est propagée', () async {
    final tokens = FakeTokens(refreshed: null);
    dio = buildDio(tokens);

    await expectLater(
      dio.get<dynamic>('/auth/v1/user'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    expect(tokens.refreshCalls, 1);
  });

  test('jamais plus d’un rejeu par requête (pas de boucle infinie)', () async {
    // Le serveur refuse même le nouveau jeton.
    final tokens = FakeTokens(refreshed: 'still-invalid');
    dio = buildDio(tokens);

    await expectLater(
      dio.get<dynamic>('/auth/v1/user'),
      throwsA(isA<DioException>()),
    );
    expect(server.receivedTokens, ['Bearer expired', 'Bearer still-invalid']);
  });

  test('401 simultanées : un seul rafraîchissement', () async {
    final tokens = FakeTokens();
    dio = buildDio(tokens);

    final responses = await Future.wait([
      for (var i = 0; i < 3; i++) dio.get<dynamic>('/auth/v1/user'),
    ]);

    expect(responses.every((r) => r.statusCode == 200), isTrue);
    expect(tokens.refreshCalls, 1);
  });
}
