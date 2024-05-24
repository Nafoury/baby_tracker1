import 'dart:math';
import 'package:flutter/material.dart';
import 'package:baba_tracker/shapes/temp6.dart';

class AnimatedMercuryPaintWidget extends StatefulWidget {
  final double temperature;

  const AnimatedMercuryPaintWidget({
    super.key,
    required this.temperature,
  });

  @override
  State<AnimatedMercuryPaintWidget> createState() =>
      _AnimatedMercuryPaintWidgetState();
}

class _AnimatedMercuryPaintWidgetState extends State<AnimatedMercuryPaintWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose of the animation controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          painter: MercuryPainter(
            animation: _animation.value,
            temperatureReduced: widget.temperature,
          ),
        );
      },
    );
  }
}
