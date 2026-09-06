import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // App Bar specific colors (#E65100 Vibrant Orange)
  static const Color appBarPrimary = Color(0xFFE65100);
  static const Color appBarSecondaryDark = Color(0xFFBF360C);
  static const Color appBarSecondary = Color(0xFFFF8F00);

  // Page Primary (#E65100 Vibrant Orange Theme)
  static const Color primary = Color(0xFFE65100);
  static const Color primaryDark = Color(0xFFBF360C);
  static const Color primaryLight = Color(0xFFFF8F00);

  static Color get primarySoft => AppThemeModeController.isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFFDF2E9);

  // Page Secondary (Terracotta Accent)
  static const Color secondary = Color(0xFFF57C00);
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color secondaryLight = Color(0xFFFFB74D);

  static Color get secondarySoft => AppThemeModeController.isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFFBEEE6);

  // Pure White & Soft Neutral App Backgrounds (Responds to Dark Mode Toggle Switch)
  static Color get background => AppThemeModeController.isDark
      ? const Color(0xFF0F172A)
      : const Color(0xFFFFFFFF);

  static Color get backgroundAlt => AppThemeModeController.isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFF8FAFC);

  static Color get surface => AppThemeModeController.isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFFFFFFF);

  static Color get surfaceMuted => AppThemeModeController.isDark
      ? const Color(0xFF0F172A)
      : const Color(0xFFF8FAFC);

  static Color get surfaceDark => const Color(0xFFBF360C);

  static Color get textPrimary => AppThemeModeController.isDark
      ? const Color(0xFFF8FAFC)
      : const Color(0xFF1E293B);

  static Color get textSecondary => AppThemeModeController.isDark
      ? const Color(0xFFCBD5E1)
      : const Color(0xFF64748B);

  static Color get textLight => AppThemeModeController.isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  static Color get border => AppThemeModeController.isDark
      ? const Color(0xFF334155)
      : const Color(0xFFE2E8F0);

  static Color get divider => AppThemeModeController.isDark
      ? const Color(0xFF334155)
      : const Color(0xFFF1F5F9);

  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color info = Color(0xFFE65100);

  static Color get infoSoft => AppThemeModeController.isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFFDF2E9);

  // Rich Gradients
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFFF7043)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get blushGradient => LinearGradient(
    colors: [
      background,
      primarySoft,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Bright Purple for Express Interest buttons
  static const Color expressInterest = Color(0xFF8B5CF6);
  static const Color expressInterestDark = Color(0xFF7C3AED);
  static const Gradient expressInterestGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient softDarkGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
