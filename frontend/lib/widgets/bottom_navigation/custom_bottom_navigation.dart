import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
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
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            label: AppLanguageController.text('nav_favourites'),
          ),
          _NavigationItem(
            icon: Icons.handshake_outlined,
            activeIcon: Icons.handshake,
            label: AppLanguageController.text('nav_interests'),
          ),
          _NavigationItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: AppLanguageController.text('nav_profile'),
          ),
        ];

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.border),
                boxShadow: AppConstants.cardShadow,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / items.length;

                  return SizedBox(
                    height: 62,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          left: currentIndex * itemWidth,
                          top: 0,
                          bottom: 0,
                          width: itemWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: AppConstants.softShadow,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(items.length, (index) {
                            final item = items[index];
                            final isSelected = index == currentIndex;

                            return Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => onTap(index),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 1,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          transitionBuilder: (child, animation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            isSelected
                                                ? item.activeIcon
                                                : item.icon,
                                            key: ValueKey(
                                              '${item.label}-$isSelected',
                                            ),
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          curve: Curves.easeOut,
                                          style: TextStyle(
                                            fontSize: 9.0,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : AppColors.textSecondary,
                                            letterSpacing: 0.0,
                                            height: 1.1,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                item.label,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
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
