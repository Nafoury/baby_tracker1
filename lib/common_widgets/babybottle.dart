import 'package:flutter/material.dart';

class BottlePainter extends CustomPainter {
  final double liquidHeight;
  final Color liquidColor;

  BottlePainter(this.liquidHeight, this.liquidColor);

  @override
  void paint(Canvas canvas, Size size) {
    var backgroundPaint = Paint()
      ..color = Colors.blue.shade50; // Set your desired background color
    canvas.drawRect(Rect.fromLTWH(-65, 0, size.width + 130, size.height + 40),
        backgroundPaint);

    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    double bottleNeckHeight = size.height * 0.2;
    double bottleBodyHeight = size.height * 0.6;
    double bottleBodyWidth = size.width * 0.4;

    // Draw the curved sides of the bottle with an ergonomic shape in the middle
    Path path = Path()
      ..moveTo(size.width / 2 + bottleBodyWidth / 2, size.height)
      ..lineTo(size.width / 2 - bottleBodyWidth / 2, size.height)
      ..lineTo(
        size.width / 2 - bottleBodyWidth / 2,
        size.height - bottleBodyHeight,
      )
      ..quadraticBezierTo(
        size.width / 2,
        size.height - bottleBodyHeight - bottleNeckHeight * 1.7,
        size.width / 2 + bottleBodyWidth / 2,
        size.height - bottleBodyHeight,
      )
      ..close();
    // Drawing the liquid
    double liquidTop = size.height - bottleBodyHeight * liquidHeight / 200.0;
    Path liquidPath = Path()
      ..moveTo(size.width / 2 + bottleBodyWidth / 2, size.height)
      ..lineTo(size.width / 2 - bottleBodyWidth / 2, size.height)
      ..lineTo(
        size.width / 2 - bottleBodyWidth / 2,
        liquidTop,
      )
      ..lineTo(size.width / 2 + bottleBodyWidth / 2,
          size.height - bottleBodyHeight * (liquidHeight / 200.0))
      ..close();

    var liquidPaint = Paint()
      ..color = liquidColor // Set the color of the liquid dynamically
      ..style = PaintingStyle.fill; // Use fill to fill the liquid

    // Draw the combined path
    canvas.drawPath(path, paint);
    canvas.drawPath(liquidPath, liquidPaint);

    final double mlMarkHeight = size.height - bottleBodyHeight;
    for (int ml = 400; ml >= 50; ml -= 50) {
      final double y = mlMarkHeight + (1 - ml / 400) * bottleBodyHeight;
      canvas.drawLine(
          Offset(size.width / 2 - 8, y), Offset(size.width / 2 + 8, y), paint);
      canvas.drawLine(
          Offset(size.width / 2 - 8, y), Offset(size.width / 2 + 8, y), paint);

      // Add text beside the specific markings with custom style
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: ml.toString(),
          style: TextStyle(
            color: Colors.blue, // Set your desired text color
            fontSize: 8, // Set your desired text size
            fontWeight: FontWeight.bold, // Set your desired font weight
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width / 2 + 12, y - 8));
    }

    // Draw the combined path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
