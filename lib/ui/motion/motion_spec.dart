import 'package:flutter/material.dart';

class MotionSpec {
  const MotionSpec._();

  // Page transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  // Card expand preview
  static const Duration cardExpandDuration = Duration(milliseconds: 200);
  static const Curve cardExpandCurve = Curves.easeOutBack;

  // Button / format click feedback
  static const Duration clickDuration = Duration(milliseconds: 100);
  static const Curve clickCurve = Curves.easeIn;

  // Popup appear
  static const Duration popupDuration = Duration(milliseconds: 180);
  static const Curve popupCurve = Curves.easeOutCubic;
}
