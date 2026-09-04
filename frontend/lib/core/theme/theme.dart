import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/colors.dart';
import '../constants/constants.dart';
import '../navigation/app_page_transitions.dart';

class AppThemeModeController {
  static const String _kThemeModePrefKey = 'selected_app_theme_mode';
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  static ThemeMode get current => notifier.value;
  static bool get isDark => notifier.value == ThemeMode.dark;

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_kThemeModePrefKey);
      if (savedMode == 'dark') {
        notifier.value = ThemeMode.dark;
      } else {
        notifier.value = ThemeMode.light;
      }
    } catch (_) {}
  }

  static Future<void> toggleTheme() async {
    final newMode = notifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    notifier.value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kThemeModePrefKey, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.robotoTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.roboto().fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Color(0xFF1E293B),
        error: AppColors.error,
        onError: Colors.white,
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF1E293B),
        primaryContainer: AppColors.primaryDark,
        secondaryContainer: AppColors.secondaryDark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1E293B),
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF64748B),
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 17.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF1F5F9),
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.poppins(
          color: const Color(0xFF64748B),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF94A3B8),
          fontSize: 13,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.secondaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        disabledColor: const Color(0xFFF8FAFC),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF64748B),
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actionTextColor: AppColors.secondaryLight,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
        },
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: WidgetStateProperty.all(0.0),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme);
    const darkBackground = Color(0xFF0F172A);
    const darkSurface = Color(0xFF1E293B);
    const darkBorder = Color(0xFF334155);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.roboto().fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: darkSurface,
        onSurface: Colors.white,
        primaryContainer: AppColors.primaryDark,
        secondaryContainer: AppColors.secondaryDark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF94A3B8),
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 17.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: AppPageTransitionsBuilder(),
          TargetPlatform.iOS: AppPageTransitionsBuilder(),
          TargetPlatform.macOS: AppPageTransitionsBuilder(),
          TargetPlatform.windows: AppPageTransitionsBuilder(),
          TargetPlatform.linux: AppPageTransitionsBuilder(),
          TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
        },
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: WidgetStateProperty.all(0.0),
      ),
    );
  }
}
