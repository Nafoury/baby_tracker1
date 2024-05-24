import 'package:flutter/material.dart';
import 'package:baba_tracker/shapes/temp7.dart';

class MercuryPainter extends CustomPainter {
  final double temperatureReduced;
  final double animation;

  MercuryPainter({
    required this.animation,
    required this.temperatureReduced,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final temperatureHeight = size.height - temperatureReduced * size.height;
    final paintColorStops = [0.0, 0.2, 0.4, 0.6, 0.8];
    paintOneWave(
      canvas,
      size,
      temperatureHeight: temperatureHeight,
      cyclicAnimationValue: (1 - animation),
      colorStops: paintColorStops,
      colors: [
        Colors.red.shade200,
        Colors.orange.shade200,
        Colors.yellow.shade200,
        Colors.green.shade200,
        Colors.blue.shade200,
      ],
    );
    paintOneWave(
      canvas,
      size,
      temperatureHeight: temperatureHeight,
      cyclicAnimationValue: animation,
      colorStops: paintColorStops,
      colors: [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.yellowAccent,
        Colors.greenAccent,
        Colors.blueAccent,
      ],
    );
  }

  @override
  bool shouldRepaint(MercuryPainter oldDelegate) =>
      animation != oldDelegate.animation ||
      temperatureReduced != oldDelegate.temperatureReduced;

  @override
  bool shouldRebuildSemantics(MercuryPainter oldDelegate) => false;
}
