import 'package:flutter/material.dart';

/// Shared page transition configuration used across the app.
class AppPageTransitions {
  AppPageTransitions._();

  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeOutCubic;
  static const Curve reverseCurve = Curves.easeInCubic;
  static const double parallaxFactor = 0.3;

  static Widget buildSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: curve,
        reverseCurve: reverseCurve,
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}

/// Applies the same slide transition to platform-default routes.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AppPageTransitions.buildSlideTransition(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
