import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/l10n_x.dart';

/// Champ de formulaire avec libellé au-dessus (« Email », « Mot de passe »).
///
/// [highlight] force une bordure colorée : rouge (erreur serveur) ou verte
/// (confirmation valide).
class LabeledTextField extends HookWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.optionalHint,
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.isPassword = false,
    this.highlight,
    this.suffix,
    this.enabled = true,
  });

  final String label;
  final String? optionalHint;
  final TextEditingController controller;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool isPassword;
  final Color? highlight;
  final Widget? suffix;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final obscured = useState(isPassword);
    final highlight = this.highlight;
    final highlightBorder = highlight == null
        ? null
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: highlight),
          );

    Widget? suffix = this.suffix;
    if (isPassword && suffix == null) {
      suffix = IconButton(
        tooltip: obscured.value
            ? context.l10n.showPassword
            : context.l10n.hidePassword,
        onPressed: () => obscured.value = !obscured.value,
        icon: Icon(
          obscured.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.poussiere,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (optionalHint != null)
                TextSpan(
                  text: ' $optionalHint',
                  style: AppTypography.label.copyWith(
                    color: AppColors.poussiere,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          style: AppTypography.label,
        ),
        const SizedBox(height: AppDimensions.sm),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscured.value,
          obscuringCharacter: '•',
          autocorrect: !isPassword,
          enableSuggestions: !isPassword,
          style: AppTypography.bodyStrong.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: isPassword && obscured.value ? 3 : null,
          ),
          cursorColor: AppColors.projecteur,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            enabledBorder: highlightBorder,
            focusedBorder: highlightBorder,
          ),
        ),
      ],
    );
  }
}
