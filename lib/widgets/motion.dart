import 'package:flutter/material.dart';

/// Fades a widget in while it slides up a little. It plays once, when the
/// widget is first built (inside a list, that is when it scrolls into view).
/// Nothing moves when the phone's "remove animations" setting is on.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 14,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  static const Duration _length = Duration(milliseconds: 420);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }
    final total = _length + delay;
    final curve = Interval(
      delay.inMilliseconds / total.inMilliseconds,
      1,
      curve: Curves.easeOutCubic,
    );
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: total,
      curve: curve,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * offset),
          child: child,
        ),
      ),
    );
  }
}

/// Smoothly animates a progress value from 0 to [target] when first shown or
/// when [target] changes. Respects reduced-motion settings.
class AnimatedProgress extends StatelessWidget {
  const AnimatedProgress({
    super.key,
    required this.target,
    required this.builder,
    this.duration = const Duration(milliseconds: 650),
  });

  final double target;
  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final clamped = target.clamp(0.0, 1.0).toDouble();
    if (MediaQuery.disableAnimationsOf(context)) {
      return builder(context, clamped);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clamped),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => builder(context, value),
    );
  }
}
