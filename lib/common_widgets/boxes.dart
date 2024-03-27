import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class Boxes extends StatelessWidget {
  final Map aobj;
  const Boxes({super.key, required this.aobj});

  @override
  Widget build(BuildContext context) {
    String birthWeight = aobj["birthWeight"] ?? "0";
    String currentWeight = aobj["currentWeight"] ?? "0";
    double change = double.parse(currentWeight) - double.parse(birthWeight);
    var media = MediaQuery.of(context).size;
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Tcolor.gray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(media.width * 0.06),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              aobj["time"].toString(),
              style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              aobj["weight"].toString(),
              style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              aobj["date"].toString(),
              style: TextStyle(
                  color: Tcolor.gray,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
