import 'package:flutter/material.dart';

class SlideAnimations extends StatelessWidget {
  final Widget child;
  final Offset beginOffset;
  final Duration duration;

  const SlideAnimations({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.2),
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: beginOffset, end: Offset.zero),
      duration: duration,
      builder: (context, offset, child) =>
          Transform.translate(offset: offset * 100, child: child,),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
