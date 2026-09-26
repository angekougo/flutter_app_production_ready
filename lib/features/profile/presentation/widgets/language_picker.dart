import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/l10n/locale_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/l10n_x.dart';

/// Nom de la langue choisie (`null` = langue de l'appareil).
String languageName(AppLocalizations l10n, Locale? locale) =>
    switch (locale?.languageCode) {
      null => l10n.languageSystem,
      'fr' => l10n.languageFrench,
      _ => l10n.languageEnglish,
    };

/// Feuille « Langue de l'application » : appareil, français ou anglais.
Future<void> showLanguagePicker(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.salle,
      builder: (_) => const LanguagePicker(),
    );

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  static const _options = <Locale?>[null, Locale('fr'), Locale('en')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(localeControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.gutter,
            0,
            AppDimensions.gutter,
            AppDimensions.md,
          ),
          child: Text(l10n.languageSheetTitle, style: AppTypography.section),
        ),
        for (final option in _options)
          ListTile(
            contentPadding: AppDimensions.screenPadding,
            selected: option == current,
            selectedColor: AppColors.projecteur,
            title: Text(
              languageName(l10n, option),
              style: AppTypography.bodyStrong,
            ),
            trailing: option == current
                ? const Icon(Icons.check_rounded, color: AppColors.projecteur)
                : null,
            onTap: () {
              ref.read(localeControllerProvider.notifier).setLocale(option);
              Navigator.of(context).pop();
            },
          ),
        const SizedBox(height: AppDimensions.lg),
      ],
    );
  }
}
