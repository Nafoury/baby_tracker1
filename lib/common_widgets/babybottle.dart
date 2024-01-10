import 'package:flutter/material.dart';

class BabyBottleSelector extends StatefulWidget {
  @override
  _BabyBottleSelectorState createState() => _BabyBottleSelectorState();
}

class _BabyBottleSelectorState extends State<BabyBottleSelector> {
  double liquidHeight = 100.0; // Initial liquid height in millimeters

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          // Adjust the liquid height based on the vertical drag
          liquidHeight -=
              details.primaryDelta! / 2; // You can adjust the sensitivity

          // Ensure the liquid height stays within the bottle
          liquidHeight = liquidHeight.clamp(0.0, 200.0);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 100.0,
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80.0),
                bottomRight: Radius.circular(85.0),
                topLeft: Radius.circular(5.0),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                width: 50.0,
                height: liquidHeight,
                color: Colors.grey, // Change color to represent the liquid
              ),
            ),
          ),
        ],
      ),
    );
  }
}
