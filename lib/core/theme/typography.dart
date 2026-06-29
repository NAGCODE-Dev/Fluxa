import 'package:financas/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.dark ? Colors.white : AppColors.textPrimary;
    final muted = brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.textMuted;

    return TextTheme(
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.08,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.15,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: muted,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: muted,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: muted,
      ),
    );
  }
}
