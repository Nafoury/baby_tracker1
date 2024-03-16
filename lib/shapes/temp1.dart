import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      center,
      size.width / 2 - 15,
      Paint()..color = Colors.blueGrey,
    );

    var path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(center.dx, center.dy + 20);
    path.lineTo(center.dx, center.dy - 20);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.blueGrey);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BubblePainter oldDelegate) => false;
}
