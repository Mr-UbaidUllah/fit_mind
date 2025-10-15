import 'package:flutter/material.dart';

class FadeAnimations extends StatelessWidget {
  final double delay;
  final Widget child;
  const FadeAnimations({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final tween = Tween(begin: 0.0, end: 1.0);
    return TweenAnimationBuilder(
      tween: tween,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, double opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }
}
