import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isMainScreen;
  final bool showNotification;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.title = 'Kongu Matrimony',
    this.isMainScreen = true,
    this.showNotification = false,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: leading ??
          ((ModalRoute.of(context)?.canPop ?? false)
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      leadingWidth: (ModalRoute.of(context)?.canPop ?? false) ? 56 : 16,
      title: ValueListenableBuilder<AppLanguage>(
        valueListenable: AppLanguageController.notifier,
        builder: (context, currentLang, _) {
          String displayTitle = title;
          final lower = title.toLowerCase().trim();
          if (isMainScreen || lower == 'kongu matrimony') {
            displayTitle = AppLanguageController.text('app_title');
          } else if (lower.contains('horoscope')) {
            displayTitle = AppLanguageController.text('nav_horoscope');
          } else if (lower.contains('favorit') || lower.contains('favourite')) {
            displayTitle = AppLanguageController.text('nav_favourites');
          } else if (lower.contains('interest')) {
            displayTitle = AppLanguageController.text('nav_interests');
          } else if (lower.contains('profile') && !lower.contains('details')) {
            displayTitle = AppLanguageController.text('nav_profile');
          }

          final bool isTamil = currentLang == AppLanguage.tamil;

          return Text(
            displayTitle,
            style: GoogleFonts.roboto(
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: isTamil ? 0.0 : 0.6,
            ),
          );
        },
      ),
      centerTitle: false,
      titleSpacing: (ModalRoute.of(context)?.canPop ?? false) ? 0 : 16,
      actions: actions ??
          [
            // 1. Dark Mode / Normal Mode Toggle Switch Button
            ValueListenableBuilder<ThemeMode>(
              valueListenable: AppThemeModeController.notifier,
              builder: (context, themeMode, _) {
                final isDark = themeMode == ThemeMode.dark;
                return Tooltip(
                  message: isDark ? 'Normal Mode / பகல் நிலை' : 'Dark Mode / இரவு நிலை',
                  child: Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: isDark,
                      onChanged: (val) => AppThemeModeController.setThemeMode(
                        val ? ThemeMode.dark : ThemeMode.light,
                      ),
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF1E293B),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.35),
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                      trackOutlineWidth: WidgetStateProperty.all(0.0),
                      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Icon(Icons.nightlight_round, color: Color(0xFFF59E0B), size: 14);
                          }
                          return const Icon(Icons.wb_sunny_rounded, color: Color(0xFFD35400), size: 14);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            // 2. Text Size Adjuster Button
            IconButton(
              tooltip: 'Adjust Text Size / எழுத்து அளவு',
              icon: const Icon(
                Icons.format_size_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () => _showFontSizeAdjusterSheet(context),
            ),
            // 3. Language Translator Button
            IconButton(
              tooltip: 'Translate / மொழி மாறா',
              icon: const Icon(
                Icons.g_translate_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () => _showLanguageSelectorSheet(context),
            ),
            const SizedBox(width: 4),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  void _showFontSizeAdjusterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (context) {
        return ValueListenableBuilder<double>(
          valueListenable: AppFontSizeController.notifier,
          builder: (context, fontScale, _) {
            final percent = (fontScale * 100).round();
            final isTamil = AppLanguageController.isTamil;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isTamil ? 'எழுத்து அளவு கட்டுப்பாடு' : 'App Text Size',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$percent%',
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        // Decrease Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: fontScale <= 0.85
                                ? null
                                : () => AppFontSizeController.decrease(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.textPrimary,
                              elevation: 0,
                              side: BorderSide(color: AppColors.border, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
                            label: Text(
                              isTamil ? 'சிறிதாக்கு' : 'Decrease',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Reset Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => AppFontSizeController.reset(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.restart_alt_rounded, size: 18),
                            label: Text(
                              isTamil ? 'இயல்பு நிலை' : 'Reset',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Increase Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: fontScale >= 1.35
                                ? null
                                : () => AppFontSizeController.increase(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                            label: Text(
                              isTamil ? 'பெரிதாக்கு' : 'Increase',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  void _showLanguageSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
      builder: (context) {
        return ValueListenableBuilder<AppLanguage>(
          valueListenable: AppLanguageController.notifier,
          builder: (context, currentLang, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.translate_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppLanguageController.text('select_language'),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLanguageController.text('choose_app_language'),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLanguageOption(
                      context: context,
                      language: AppLanguage.english,
                      label: AppLanguageController.text('english_label'),
                      isSelected: currentLang == AppLanguage.english,
                    ),
                    const SizedBox(height: 10),
                    _buildLanguageOption(
                      context: context,
                      language: AppLanguage.tamil,
                      label: AppLanguageController.text('tamil_label'),
                      isSelected: currentLang == AppLanguage.tamil,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required AppLanguage language,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        AppLanguageController.setLanguage(language);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
