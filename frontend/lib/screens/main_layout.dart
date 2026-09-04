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

    setState(() {
      _navigationForward = index > _currentIndex;
      _tabHistory.add(_currentIndex);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMainScreen: _currentIndex == 0,
        showNotification: _currentIndex == 0,
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
      body: ValueListenableBuilder<ThemeMode>(
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToTab,
      ),
    );
  }
}
