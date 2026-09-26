import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';

enum SnackTone { success, error, info }

/// Notification courte. Le [ScaffoldMessenger] est celui de l'application :
/// le message reste visible même si l'écran courant est remplacé
/// (ex. redirection vers l'accueil après la connexion).
void showAppSnackBar(
  ScaffoldMessengerState messenger,
  String message, {
  SnackTone tone = SnackTone.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final (icon, color) = switch (tone) {
    SnackTone.success => (Icons.check_circle_rounded, AppColors.menthe),
    SnackTone.error => (Icons.error_outline_rounded, AppColors.signal),
    SnackTone.info => (Icons.info_outline_rounded, AppColors.nuit),
  };
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: AppColors.projecteur,
                onPressed: onAction ?? () {},
              ),
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
