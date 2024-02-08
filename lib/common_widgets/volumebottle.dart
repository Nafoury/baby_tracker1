import 'package:baby_tracker/common_widgets/babybottle.dart';
import 'package:flutter/material.dart';

class BabyBottleSelector extends StatefulWidget {
  @override
  _BabyBottleSelectorState createState() => _BabyBottleSelectorState();
}

class _BabyBottleSelectorState extends State<BabyBottleSelector> {
  double insideLiquidHeight = 0.0;
  final double maxLiquidHeight = 200.0;
  double mlValue = 0.0; // Declare mlValue outside the callback
  Color liquidColor = Colors.blue; // Set your desired default liquid color

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Display liquid inside the bottle
        CustomPaint(
          painter: BottlePainter(insideLiquidHeight, liquidColor),
          size: Size(180, 250),
        ),
        // GestureDetector for dragging the liquid inside the bottle
        GestureDetector(
          onVerticalDragUpdate: (details) {
            int direction = details.primaryDelta! > 0 ? 1 : -1;
            setState(() {
              double newLiquidHeight =
                  insideLiquidHeight - details.primaryDelta!;
              // Adjust the calculation to match your desired maximum liquid height
              insideLiquidHeight = newLiquidHeight.clamp(0.0, maxLiquidHeight);
              // Update mlValue within the callback
              mlValue = (insideLiquidHeight / maxLiquidHeight) * 400.0;

              // Update liquidColor based on some logic (e.g., based on mlValue)
              liquidColor = calculateLiquidColor(mlValue);
            });

            // Print the actual milliliter value
            print('Drag Update: ${mlValue}');

            // Update the UI with the new mlValue
            setState(() {});
          },
          child: Container(
            width: 50.0,
            height: 45, // Set the height to the maximum allowed liquid height
            color: Colors.transparent,
            child: Center(
              child: Text(
                ' ${mlValue.toStringAsFixed(1)}ml',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color calculateLiquidColor(double mlValue) {
    // Add your logic to determine the color based on mlValue
    // Example: Change color based on mlValue range
    if (mlValue <= 200) {
      return Colors.blue.shade100;
    } else {
      return Colors.blue.shade200;
    }
  }
}
