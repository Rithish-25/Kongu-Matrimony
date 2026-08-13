import 'package:flutter/material.dart';
import 'app_page_transitions.dart';

/// Creates a route with the app's standard horizontal slide transition.
Route<T> appPageRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: AppPageTransitions.buildSlideTransition,
    transitionDuration: AppPageTransitions.duration,
    reverseTransitionDuration: AppPageTransitions.duration,
  );
}
