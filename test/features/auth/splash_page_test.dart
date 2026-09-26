import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app_production_ready/features/auth/domain/usecases/auth_usecases.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Réseau qui ne répond jamais (cas qui bloquait le Splash).
class _HangingNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected => Completer<bool>().future;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpSplash(WidgetTester tester, {AppUser? user}) async {
    final repository = _MockAuthRepository();
    when(() => repository.currentUser).thenReturn(user);

    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, _) => const SplashPage()),
        GoRoute(path: '/login', builder: (_, _) => const Text('LOGIN')),
        GoRoute(path: '/home', builder: (_, _) => const Text('HOME')),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          networkInfoProvider.overrideWithValue(_HangingNetworkInfo()),
          getCurrentUserProvider.overrideWithValue(GetCurrentUser(repository)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  testWidgets('sans session → Login, même si le réseau ne répond pas', (
    tester,
  ) async {
    await pumpSplash(tester);
    expect(find.text('LOGIN'), findsOneWidget);
  });

  testWidgets('session existante → Accueil', (tester) async {
    await pumpSplash(
      tester,
      user: const AppUser(id: '1', email: 'awa@exemple.com'),
    );
    expect(find.text('HOME'), findsOneWidget);
  });
}
