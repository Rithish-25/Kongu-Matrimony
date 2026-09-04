import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/localization/app_language.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppLanguageController.notifier,
      builder: (context, currentLang, _) {
        final items = [
          _NavigationItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: AppLanguageController.text('nav_home'),
          ),
          _NavigationItem(
            icon: Icons.search_rounded,
            activeIcon: Icons.search_rounded,
            label: AppLanguageController.text('nav_horoscope'),
          ),
          _NavigationItem(
            icon: Icons.handshake_outlined,
            activeIcon: Icons.handshake,
            label: AppLanguageController.text('nav_interests'),
          ),
          _NavigationItem(
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            label: AppLanguageController.text('nav_favourites'),
          ),
          _NavigationItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: AppLanguageController.text('nav_profile'),
          ),
        ];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 58,
              child: Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;

                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onTap(index),
                        splashColor: Colors.white.withValues(alpha: 0.15),
                        highlightColor: Colors.white.withValues(alpha: 0.08),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                              size: isSelected ? 23 : 21,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
