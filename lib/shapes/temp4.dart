import 'dart:math';
import 'package:flutter/material.dart';
import 'package:baby_tracker/shapes/temp5.dart';

class Thermometer extends StatelessWidget {
  final ValueNotifier<double> temperature;

  const Thermometer(this.temperature, {super.key});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    final maxWidth = min(200.0, MediaQuery.of(context).size.width / 2 - 60);
    // Same as the slider here.

    final maxContainedMercuryHeight = maxHeight - 60;
    final maxContainedMercuryWidth = maxWidth - 20;

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Center(
        child: Container(
          height: maxContainedMercuryHeight,
          width: maxContainedMercuryWidth,
          // This part with Container could have been done with a Padding
          // with edge insets symetric as well, but simpler to deal with height and width.
          decoration: ShapeDecoration(
            color: Colors.blue.shade100,
            shape: const StadiumBorder(),
          ),
          clipBehavior: Clip.antiAlias,
          // Clip needed to keep the content of this container inside
          // (Mercury is toxic be careful)
          child: ValueListenableBuilder(
            valueListenable: temperature,
            builder: (context, value, _) {
              return AnimatedMercuryPaintWidget(
                temperature: value,
              );
            },
          ),
        ),
      ),
    );
  }
}
