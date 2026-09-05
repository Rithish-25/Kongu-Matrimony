import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/theme.dart';

import '../core/navigation/tab_page_transition.dart';
import '../widgets/bottom_navigation/custom_bottom_navigation.dart';
import '../widgets/appbar/custom_app_bar.dart';
import 'home/home_screen.dart';
import 'horoscope/horoscope_screen.dart';
import 'favourites/favourites_screen.dart';
import 'interests/interests_screen.dart';
import 'profile/profile_screen.dart';

import '../core/assets/mock_data.dart';
import '../widgets/drawer/app_drawer.dart';
import '../widgets/auth_required_dialog.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  bool _navigationForward = true;
  final List<int> _tabHistory = [];
  late final List<Widget> _screens = [
    HomeScreen(onNavigateToTab: _navigateToTab),
    const HoroscopeScreen(),
    const InterestsScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
  ];

  void _navigateToTab(int index) {
    if (index == _currentIndex) {
      return;
    }

    // Interests (2) and Favourites (3) require Login / Registration
    if ((index == 2 || index == 3) && !ProfileDatabase.isLoggedIn) {
      String? featureName;
      if (index == 2) featureName = 'Interests';
      if (index == 3) featureName = 'Favourites';

      AuthRequiredDialog.show(context, featureName: featureName);
      return;
    }

    setState(() {
      _navigationForward = index > _currentIndex;
      _tabHistory.add(_currentIndex);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _currentIndex == 0 ? const AppDrawer() : null,
      appBar: CustomAppBar(
        isMainScreen: _currentIndex == 0,
        showNotification: _currentIndex == 0,
        showBackButton: false,
        leading: _currentIndex == 0
            ? Builder(
                builder: (context) => IconButton(
                  tooltip: 'Menu',
                  icon: const Icon(
                    Icons.menu_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: _currentIndex == 0
            ? 'Kongu Kootamaipu'
            : _currentIndex == 1
                ? 'Horoscope'
                : _currentIndex == 2
                    ? 'Interests'
                    : _currentIndex == 3
                        ? 'Favorites'
                        : 'Profile',
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: ProfileDatabase.authNotifier,
        builder: (context, isLoggedIn, _) {
          // Reset tab to Home if logged out while viewing protected tab
          if (!isLoggedIn && (_currentIndex == 2 || _currentIndex == 3)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentIndex = 0;
                });
              }
            });
          }

          return ValueListenableBuilder<ThemeMode>(
            valueListenable: AppThemeModeController.notifier,
            builder: (context, _, __) {
              return WillPopScope(
                onWillPop: () async {
                  // If not on Home tab, go to Home and consume the back event
                  if (_currentIndex != 0) {
                    setState(() {
                      _navigationForward = 0 > _currentIndex ? false : true;
                      _tabHistory.add(_currentIndex);
                      _currentIndex = 0;
                    });
                    return false;
                  }

                  // On Home tab: show non-dismissible exit confirmation
                  final shouldExit = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: AlertDialog(
                          title: const Text('Exit'),
                          content: const Text('Are you sure you want to exit?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  if (shouldExit == true) {
                    // Exit the app
                    SystemNavigator.pop();
                  }
                  return false;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: TabPageTransition(
                        currentIndex: _currentIndex,
                        forward: _navigationForward,
                        children: _screens,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToTab,
      ),
    );
  }
}
