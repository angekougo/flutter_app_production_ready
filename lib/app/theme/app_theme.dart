import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    const colorScheme = ColorScheme.dark(
      primary: AppColors.projecteur,
      onPrimary: AppColors.onProjecteur,
      secondary: AppColors.nuit,
      onSecondary: AppColors.encre,
      error: AppColors.signal,
      onError: AppColors.encre,
      surface: AppColors.encre,
      onSurface: AppColors.papier,
      onSurfaceVariant: AppColors.poussiere,
      surfaceContainerLow: AppColors.salle,
      surfaceContainer: AppColors.salle,
      surfaceContainerHigh: AppColors.velours,
      outline: AppColors.trait,
      outlineVariant: AppColors.trait,
    );

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      borderSide: BorderSide(color: color),
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
    );
    const buttonSize = Size.fromHeight(AppDimensions.buttonHeight);

    Color navColor(Set<WidgetState> states) =>
        states.contains(WidgetState.selected)
        ? AppColors.projecteur
        : AppColors.poussiere;

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.encre,
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme)
          .apply(bodyColor: AppColors.papier, displayColor: AppColors.papier),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.encre,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.section,
        iconTheme: const IconThemeData(color: AppColors.papier),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.projecteur,
          foregroundColor: AppColors.onProjecteur,
          disabledBackgroundColor: AppColors.projecteur.withValues(alpha: 0.4),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.papier,
          side: const BorderSide(color: AppColors.trait),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: AppTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.projecteur,
          textStyle: AppTypography.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.salle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.lg,
        ),
        hintStyle: AppTypography.body.copyWith(
          color: AppColors.poussiere.withValues(alpha: 0.7),
        ),
        border: border(AppColors.trait),
        enabledBorder: border(AppColors.trait),
        focusedBorder: border(AppColors.projecteur),
        errorBorder: border(AppColors.signal),
        focusedErrorBorder: border(AppColors.signal),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.signal),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.encre,
        selectedColor: AppColors.projecteur,
        side: const BorderSide(color: AppColors.trait),
        shape: const StadiumBorder(),
        labelStyle: AppTypography.label,
        secondaryLabelStyle: AppTypography.label.copyWith(
          color: AppColors.onProjecteur,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.trait,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.velours,
        contentTextStyle: AppTypography.bodyStrong,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.projecteur,
        linearTrackColor: AppColors.salle,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navBar,
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: navColor(states),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(color: navColor(states)),
        ),
      ),
    );
  }
}
