import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  static const Color primary = Color(0xFF7A102A);
  static const Color primaryDark = Color(0xFF4D0818);
  static const Color primaryLight = Color(0xFFA72A47);
  static const Color primarySoft = Color(0xFFF8E9ED);

  static const Color secondary = Color(0xFFD4A937);
  static const Color secondaryDark = Color(0xFF9B7410);
  static const Color secondaryLight = Color(0xFFE8C66B);
  static const Color secondarySoft = Color(0xFFFBF4DE);

  static const Color background = Color(0xFFF8F4EF);
  static const Color backgroundAlt = Color(0xFFF3ECE4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFFCFAF7);
  static const Color surfaceDark = Color(0xFF25171B);

  static const Color textPrimary = Color(0xFF21171A);
  static const Color textSecondary = Color(0xFF6D5960);
  static const Color textLight = Color(0xFF9C8A8F);

  static const Color border = Color(0xFFE8D9D9);
  static const Color divider = Color(0xFFF0E5E1);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D5B);
  static const Color successSoft = Color(0xFFE2F3EA);
  static const Color warning = Color(0xFF9B7410);
  static const Color warningSoft = Color(0xFFFBF2D7);
  static const Color info = Color(0xFF8B1E3F);
  static const Color infoSoft = Color(0xFFF7E8EC);

  // Brand gradients
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFF2D789), Color(0xFFD4A937), Color(0xFFB78311)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB0324F), Color(0xFF7A102A), Color(0xFF4D0818)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFF3B0A16), Color(0xFF7A102A), Color(0xFFB0324F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient blushGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8E9ED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient softDarkGradient = LinearGradient(
    colors: [Color(0xFF29171C), Color(0xFF160D10)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
