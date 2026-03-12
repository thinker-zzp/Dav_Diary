import 'package:diary/ui/motion/motion_spec.dart';
import 'package:flutter/material.dart';

Route<T> buildPageTransitionRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: MotionSpec.pageTransitionDuration,
    reverseTransitionDuration: MotionSpec.pageTransitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: MotionSpec.pageTransitionCurve,
        reverseCurve: MotionSpec.pageTransitionCurve,
      );
      final offsetTween = Tween<Offset>(
        begin: const Offset(0.035, 0),
        end: Offset.zero,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: offsetTween.animate(curved),
          child: child,
        ),
      );
    },
  );
}

Route<T> buildCardExpandPreviewRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: MotionSpec.cardExpandDuration,
    reverseTransitionDuration: MotionSpec.cardExpandDuration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: MotionSpec.cardExpandCurve,
        reverseCurve: MotionSpec.pageTransitionCurve,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}
