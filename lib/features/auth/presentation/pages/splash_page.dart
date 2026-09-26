import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../providers/auth_providers.dart';

/// Vérifie la session restaurée et l'état du réseau, puis redirige vers
/// l'accueil (session existante) ou la connexion.
class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  static const _minimumDisplay = Duration(milliseconds: 1200);
  static const _networkCheckTimeout = Duration(seconds: 2);

  Future<void> _bootstrap(BuildContext context, WidgetRef ref) async {
    try {
      await Future.wait([
        Future<void>.delayed(_minimumDisplay),
        // Simple vérification : l'accès aux données ne dépend pas de ce
        // résultat (le Repository retombe sur le cache si besoin).
        ref
            .read(networkInfoProvider)
            .isConnected
            .timeout(_networkCheckTimeout, onTimeout: () => false),
      ]);
    } on Object catch (e) {
      debugPrint('[splash] vérification réseau impossible : $e');
    } finally {
      // Quoi qu'il arrive, le Splash ne doit jamais rester bloqué.
      if (context.mounted) {
        final user = ref.read(getCurrentUserProvider)();
        context.go(user != null ? RoutePaths.home : RoutePaths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Une seule fois, au premier affichage.
    useEffect(() {
      unawaited(_bootstrap(context, ref));
      return null;
    }, const []);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppConstants.appName, style: AppTypography.display),
              const SizedBox(height: AppDimensions.md),
              Text(context.l10n.appTagline, style: AppTypography.originalTitle),
            ],
          ),
        ),
      ),
    );
  }
}
