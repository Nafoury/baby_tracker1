import 'dart:math';
import 'package:flutter/material.dart';
import 'package:baba_tracker/shapes/temp.dart';

class SliderTemperature extends StatelessWidget {
  final ValueNotifier<double> temperature;

  const SliderTemperature(this.temperature, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: min(100, MediaQuery.of(context).size.width / 2 - 60),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sliderMaxY = constraints.maxHeight - 100;
          double startingPositionY = temperature.value * sliderMaxY;

          return AnimatedBuilder(
            animation: temperature,
            builder: (context, _) {
              final sliderPositionY = temperature.value * sliderMaxY;

              return Stack(
                children: [
                  Positioned(
                    bottom: sliderPositionY,
                    right: 15,
                    child: GestureDetector(
                      onVerticalDragStart: (startDetails) {
                        startingPositionY = sliderPositionY;
                      },
                      onVerticalDragEnd: (endDetails) {},
                      onVerticalDragUpdate: (updateDetails) {
                        final newSliderPositionY =
                            startingPositionY - updateDetails.localPosition.dy;
                        final newPotentialTemperature =
                            newSliderPositionY / sliderMaxY;
                        temperature.value =
                            max(0, min(1, newPotentialTemperature));
                      },
                      child: BubbleTemperatureIndicator(
                        // Adjusted to allow floating-point numbers
                        temperature:
                            ((temperature.value * 5) + 37.0), // Change here
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
