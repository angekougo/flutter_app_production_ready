import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/core_providers.dart';
import '../providers/auth_providers.dart';

/// Vérifie la session restaurée et l'état du réseau, puis redirige vers
/// l'accueil (session existante) ou la connexion.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  static const _minimumDisplay = Duration(milliseconds: 1200);
  static const _networkCheckTimeout = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
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
      if (mounted) {
        final user = ref.read(getCurrentUserProvider)();
        context.go(user != null ? RoutePaths.home : RoutePaths.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppConstants.appName, style: AppTypography.display),
              const SizedBox(height: AppDimensions.md),
              Text(
                'Le cinéma, même hors connexion.',
                style: AppTypography.originalTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
