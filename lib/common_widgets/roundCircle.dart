import 'package:flutter/material.dart';

class RoundCircle extends StatelessWidget {
  const RoundCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, // Set the width
      height: 10, // Set the height
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade100, // Customize the color as needed
      ),
    );
  }
}
