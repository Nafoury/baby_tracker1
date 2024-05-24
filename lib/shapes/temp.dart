import 'package:flutter/material.dart';
import 'package:baba_tracker/shapes/temp1.dart';

class BubbleTemperatureIndicator extends StatelessWidget {
  final double temperature;

  const BubbleTemperatureIndicator({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: BubblePainter(),
        child: Center(
          child: Text(
            temperature.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
