import 'package:baba_tracker/models/momweightData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeightChart extends StatelessWidget {
  final List<MomData> weightRecords;
  const WeightChart({required this.weightRecords});

  @override
  Widget build(BuildContext context) {
    if (weightRecords.length < 2) {
      // Display a message indicating that there is no data available
      return Padding(
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/weigh_scale.png',
                height: 90,
                width: 90,
              ),
              Text(" no weight data to show")
            ],
          ),
        ),
      );
    }
    List<FlSpot> spots = [];

    // Convert weightRecords into FlSpot objects
    for (int i = 0; i < weightRecords.length; i++) {
      double x = i.toDouble(); // x-coordinate representing time
      double y = weightRecords[i].weight!; // Parse weight as double
      spots.add(FlSpot(x, y));
    }
    double minWeight =
        weightRecords.map((record) => record.weight!).reduce(min);
    double maxWeight =
        weightRecords.map((record) => record.weight!).reduce(max);

    double yMin = minWeight - 1.0; // Adjust for padding
    double yMax = maxWeight + 1.0; // Adjust for padding

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Overview",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 1.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              'Weight',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 300,
          width: 300,
          child: LineChart(
            LineChartData(
              minY: yMin - 15,
              maxY: yMax,
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.transparent),
                  bottom: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.transparent),
                ),
              ),
              titlesData: titlesData,
              gridData: FlGridData(show: true, drawHorizontalLine: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 50,
                  tooltipBgColor: Colors.white,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: touchedSpot.bar.gradient?.colors[0] ??
                            touchedSpot.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      );
                      return LineTooltipItem(
                        '${touchedSpot.y.toStringAsFixed(1)}',
                        textStyle,
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                longPressDuration: Durations.long1,
                getTouchLineStart: (data, index) => 0,
              ),
              lineBarsData: [
                LineChartBarData(
                  color: Colors.blue.shade400,
                  spots: spots,
                  isCurved: true,
                  isStrokeCapRound: true,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        Text(
          'Start                                                                                            Last',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 20,
            getTitlesWidget: (value, meta) {
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.black12.withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );
}
