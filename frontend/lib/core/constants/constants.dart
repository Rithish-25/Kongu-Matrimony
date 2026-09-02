import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // Spacing (Compact and consistent)
  static const double spacingXS = 6.0;
  static const double spacingS = 10.0;
  static const double spacingM = 14.0;
  static const double spacingL = 20.0;
  static const double spacingXL = 28.0;
  static const double spacingXXL = 36.0;

  // Border Radii
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusSmall = 12.0;
  static const double buttonRadius = 16.0;

  // Shadow styles (Soft, Premium, Neutral)
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0x0F000000),
      blurRadius: 18.0,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 24.0,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> goldShadow = [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 16.0,
      offset: const Offset(0, 8),
    ),
  ];
}
