import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

void paintOneWave(
  Canvas canvas,
  Size size, {
  required double temperatureHeight,
  required double cyclicAnimationValue,
  required List<double> colorStops,
  required List<Color> colors,
}) {
  assert(colorStops.length == colors.length); // Verifying equal lengths

  Path path = Path();

  path.moveTo(0, temperatureHeight);

  for (double i = 0.0; i < size.width; i++) {
    path.lineTo(
      i,
      temperatureHeight +
          sin((i / size.width * 2 * pi) + (cyclicAnimationValue * 2 * pi)) * 8,
    );
  } // Math "magic" for the sinus waves.
  // I did not know prior to making this that we could actually create for loops
  // with double index in Dart, but apparently we can.
  // Here 8 is the amplitude of th sin wave, and the frequency (x + cyclicAnimationValue)
  // Where x is the horizontal parameter going from 0 to 1.
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();
  // Then we simply close the path.

  Paint paint = Paint();
  paint.shader = ui.Gradient.linear(
    const Offset(0, 0),
    Offset(0, size.height),
    colors,
    colorStops,
  );
  // We put the gradient with a shader
  // Since the shader goes from 0 to maximum height, we fulfill the requirement
  // Of having the gradient not dependant of the temperature value.

  canvas.drawPath(path, paint);
}
