import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class Boxes extends StatelessWidget {
  final Map aobj;
  final List<Map<String, dynamic>> weightboxes;
  const Boxes({super.key, required this.aobj, required this.weightboxes});

  @override
  Widget build(BuildContext context) {
    String birthWeight = aobj["weight"] ?? "0"; // Access "weight" directly
    String date = aobj["date"] ?? ""; // Access "date" directly
    String time = aobj["time"] ?? "";

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Tcolor.gray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              birthWeight + " kg", // Display birth weight
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDetails(Map<String, dynamic> data) {
    if (data["time"] == "At birth") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${data["weight"]} kg",
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${data["date"]}",
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (data["time"] == "Current") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${data["weight"]} kg",
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${data["date"]}",
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (data["time"] == "Change") {
      double birthWeight = double.parse(weightboxes[0]["weight"] ?? "0");
      double currentWeight = double.parse(weightboxes[1]["weight"] ?? "0");
      double change = currentWeight - birthWeight;
      String changeString = change.toStringAsFixed(2);
      String sign = change >= 0 ? "+" : "-";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change: $sign $changeString kg",
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return SizedBox();
  }
}
