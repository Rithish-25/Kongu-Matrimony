import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // App Bar specific colors (Gradient Vibrant Orange)
  static const Color appBarPrimary = Color(0xFFE65100);
  static const Color appBarSecondaryDark = Color(0xFFBF360C);
  static const Color appBarSecondary = Color(0xFFF57C00);

  // Page Primary (Vibrant Orange Theme)
  static const Color primary = Color(0xFFE65100);
  static const Color primaryDark = Color(0xFFBF360C);
  static const Color primaryLight = Color(0xFFFF7043);
  static const Color primarySoft = Color(0xFFFFF3E0);

  // Page Secondary (Warm Amber)
  static const Color secondary = Color(0xFFF57C00);
  static const Color secondaryDark = Color(0xFFBF360C);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondarySoft = Color(0xFFFFF8E1);

  // Pure White & Soft Neutral App Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundAlt = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFFBF360C);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color info = Color(0xFFE65100);
  static const Color infoSoft = Color(0xFFFFF3E0);

  // Vibrant Gradient Orange Theme
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFFF6D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient blushGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFFF3E0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient softDarkGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
