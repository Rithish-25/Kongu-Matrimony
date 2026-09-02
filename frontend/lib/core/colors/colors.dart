import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // App Bar specific colors (Matching kongumanamakkal.com green & warm gold)
  static const Color appBarPrimary = Color(0xFF026135);
  static const Color appBarSecondaryDark = Color(0xFF9E751D);
  static const Color appBarSecondary = Color(0xFFD4A337);

  // Page Primary (Kongu Forest Green - Simple & Traditional)
  static const Color primary = Color(0xFF026135);
  static const Color primaryDark = Color(0xFF014726);
  static const Color primaryLight = Color(0xFF1B8A52);
  static const Color primarySoft = Color(0xFFEBF7F0);

  // Page Secondary (Muted Warm Gold)
  static const Color secondary = Color(0xFFD4A337);
  static const Color secondaryDark = Color(0xFF9E751D);
  static const Color secondaryLight = Color(0xFFE6C265);
  static const Color secondarySoft = Color(0xFFFFF9EB);

  // Pure White & Soft Neutral App Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundAlt = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF014726);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF026135);
  static const Color successSoft = Color(0xFFEBF7F0);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF026135);
  static const Color infoSoft = Color(0xFFEBF7F0);

  // Simple, elegant gradients
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFE6C265), Color(0xFFD4A337)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF026135), Color(0xFF014726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFF026135), Color(0xFF014726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient blushGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFEBF7F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient softDarkGradient = LinearGradient(
    colors: [Color(0xFF026135), Color(0xFF014726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
