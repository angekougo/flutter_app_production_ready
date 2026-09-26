import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../domain/validators/auth_validators.dart';

/// Quatre segments + « 8 caractères minimum · robustesse correcte ».
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.strength});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = strength == PasswordStrength.weak
        ? AppColors.signal
        : AppColors.projecteur;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    decoration: BoxDecoration(
                      color: i < strength.score ? color : AppColors.trait,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            [
              l10n.passwordMinLength(AuthValidators.minPasswordLength),
              if (strength != PasswordStrength.empty)
                l10n.passwordStrengthLabel(strength),
            ].join(' · '),
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
