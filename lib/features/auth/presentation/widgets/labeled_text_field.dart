import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';

/// Champ de formulaire avec libellé au-dessus (« Email », « Mot de passe »).
///
/// [highlight] force une bordure colorée : rouge (erreur serveur) ou verte
/// (confirmation valide).
class LabeledTextField extends StatefulWidget {
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
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.highlight;
    final highlightBorder = highlight == null
        ? null
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide(color: highlight),
          );

    Widget? suffix = widget.suffix;
    if (widget.isPassword && suffix == null) {
      suffix = IconButton(
        tooltip: _obscured ? 'Afficher' : 'Masquer',
        onPressed: () => setState(() => _obscured = !_obscured),
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.poussiere,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.label,
            children: [
              if (widget.optionalHint != null)
                TextSpan(
                  text: ' ${widget.optionalHint}',
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
          controller: widget.controller,
          enabled: widget.enabled,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          obscureText: _obscured,
          obscuringCharacter: '•',
          autocorrect: !widget.isPassword,
          enableSuggestions: !widget.isPassword,
          style: AppTypography.bodyStrong.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: widget.isPassword && _obscured ? 3 : null,
          ),
          cursorColor: AppColors.projecteur,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: suffix,
            enabledBorder: highlightBorder,
            focusedBorder: highlightBorder,
          ),
        ),
      ],
    );
  }
}
