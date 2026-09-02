import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/localization/app_language.dart';

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
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appBarPrimary.withValues(alpha: 0),
                AppColors.appBarSecondary.withValues(alpha: 0.45),
                AppColors.appBarPrimary.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: leading ??
          ((ModalRoute.of(context)?.canPop ?? false)
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: AppColors.appBarPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : IconButton(
                  tooltip: 'Translate / மொழி',
                  icon: const Icon(
                    Icons.g_translate_rounded,
                    color: AppColors.appBarPrimary,
                    size: 22,
                  ),
                  onPressed: () => _showLanguageSelectorSheet(context),
                )),
      leadingWidth: 56,
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

          return Container(
            constraints: const BoxConstraints(maxWidth: 210),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: AppConstants.softShadow,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                displayTitle,
                style: isTamil
                    ? GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarPrimary,
                      )
                    : GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarPrimary,
                        letterSpacing: 1.0,
                      ),
              ),
            ),
          );
        },
      ),
      centerTitle: true,
      actions: actions ??
          [
            if (showNotification)
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingM),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.appBarPrimary,
                        size: 24,
                      ),
                      onPressed: () => _showNotificationsSheet(context),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  void _showNotificationsSheet(BuildContext context) {
    final profiles = ProfileDatabase.currentProfiles;
    final userState = ProfileDatabase.userProfileNotifier.value;
    final receivedCount =
        profiles
            .where((profile) => profile.interestStatus == 'received')
            .length;
    final acceptedCount =
        profiles
            .where((profile) => profile.interestStatus == 'accepted')
            .length;
    final favouriteCount =
        profiles.where((profile) => profile.isFavourite).length;

    final notifications = <Map<String, String>>[];

    if (receivedCount > 0) {
      notifications.add({
        'title':
            '$receivedCount interest request${receivedCount > 1 ? 's' : ''} waiting',
        'subtitle': 'Open the Interests tab to accept or decline new requests.',
      });
    }
    if (acceptedCount > 0) {
      notifications.add({
        'title':
            '$acceptedCount match connection${acceptedCount > 1 ? 's' : ''} accepted',
        'subtitle': 'You now have active conversations ready to continue.',
      });
    }
    if (favouriteCount > 0) {
      notifications.add({
        'title':
            '$favouriteCount profile${favouriteCount > 1 ? 's' : ''} saved',
        'subtitle': 'Your shortlist is available in the Favourites tab.',
      });
    }
    notifications.add({
      'title': 'Membership: ${userState.plan}',
      'subtitle': 'Horoscope downloads used: ${userState.downloadedCount}',
    });

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...notifications.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primarySoft,
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      item['title'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      item['subtitle'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
