import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Bouton rond translucide posé sur une image (retour, favori).
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.papier,
    this.size = 48,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: size * 0.46),
      style: IconButton.styleFrom(
        fixedSize: Size.square(size),
        foregroundColor: color,
        backgroundColor: AppColors.encre.withValues(alpha: 0.72),
        side: BorderSide(color: AppColors.papier.withValues(alpha: 0.08)),
      ),
    );
  }
}
