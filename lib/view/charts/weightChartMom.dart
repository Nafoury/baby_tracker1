import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WeightChart extends StatelessWidget {
  final List<Map<String, dynamic>> weightRecords;
  const WeightChart({required this.weightRecords});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    // Convert weightRecords into FlSpot objects
    for (int i = 0; i < weightRecords.length; i++) {
      double x = i.toDouble(); // x-coordinate representing time
      double y =
          weightRecords[i]['weight'].toDouble(); // Parse weight as double
      spots.add(FlSpot(x, y));
    }

    return LineChart(LineChartData(
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
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          maxContentWidth: 100,
          tooltipBgColor: Colors.white,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors[0] ??
                    touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(1)}',
                textStyle,
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
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
          dotData: const FlDotData(show: false),
        ),
      ],
    ));
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
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
            showTitles: true,
            reservedSize: 25,
            interval: 100,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toString(),
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black12.withOpacity(0.4),
                    fontWeight: FontWeight.w700),
              );
            },
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
