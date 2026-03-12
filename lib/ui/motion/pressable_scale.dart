import 'package:diary/ui/motion/motion_spec.dart';
import 'package:flutter/material.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, super.key});

  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: MotionSpec.clickDuration,
        curve: MotionSpec.clickCurve,
        child: widget.child,
      ),
    );
  }
}
