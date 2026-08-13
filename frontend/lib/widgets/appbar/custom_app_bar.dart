import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/assets/mock_data.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';

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
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0),
                AppColors.secondary.withValues(alpha: 0.45),
                AppColors.primary.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      leading:
          leading ??
          (((ModalRoute.of(context)?.canPop ?? false))
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null),
      leadingWidth:
          (leading != null || (ModalRoute.of(context)?.canPop ?? false)) ? 56 : 0,
      title: (() {
        final String cleanTitle = title.trim();
        final List<String> parts = (() {
          final text = cleanTitle.toUpperCase();
          if (text.contains(' ')) {
            final index = text.indexOf(' ');
            return [text.substring(0, index), text.substring(index)];
          } else {
            if (text.length <= 3) {
              return [text, ''];
            }
            final half = (text.length / 2).ceil();
            return [text.substring(0, half), text.substring(half)];
          }
        })();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: AppConstants.softShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                parts[0],
                style: GoogleFonts.cinzel(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              if (parts[1].isNotEmpty)
                Text(
                  parts[1],
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryDark,
                    letterSpacing: 1.2,
                  ),
                ),
            ],
          ),
        );
      })(),
      centerTitle: true,
      actions:
          actions ??
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
                        color: AppColors.primary,
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
}
