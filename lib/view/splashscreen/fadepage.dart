import 'package:flutter/material.dart';

// Custom Fade Page Route untuk transisi yang smooth
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;

  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 1000), // Slow fade transition
    this.reverseDuration = const Duration(milliseconds: 800),
    RouteSettings? settings,
  }) : super(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition dengan curve yang smooth
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        );
}