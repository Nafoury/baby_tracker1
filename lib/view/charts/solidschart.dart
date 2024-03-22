import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BarChartSample5 extends StatelessWidget {
  final List<SolidsData> solidsData;

  const BarChartSample5({Key? key, required this.solidsData}) : super(key: key);

  static const double barWidth = 22;
  static int touchedIndex = -2;

  BarChartGroupData generateGroup(int x, List<Map<String, dynamic>> data) {
    final isTouched = touchedIndex == x;

    // Colors for different categories
    final Map<String, Color> categoryColors = {
      'fruits': Colors.pink,
      'veg': Colors.green,
      'protein': Colors.brown.shade200,
      'grains': Colors.blue.shade100,
      'dairy': Colors.cyan,
    };

    final List<BarChartRodData> rods = [];
    double sum = 0; // Move the sum calculation outside the loop

    for (var item in data) {
      sum += item['fruits'] +
          item['veg'] +
          item['protein'] +
          item['grains'] +
          item['dairy'];
    }

    final category = ['fruits', 'veg', 'protein', 'grains', 'dairy'];
    for (int i = 0; i < 5; i++) {
      final categorySum = data.fold<double>(
          0, (acc, item) => acc + (item[category[i]]?.toDouble() ?? 0));

      rods.add(BarChartRodData(
        toY: sum,
        width: barWidth,
        borderRadius:
            isTouched ? BorderRadius.circular(7) : BorderRadius.circular(0),
        rodStackItems: [
          BarChartRodStackItem(
            0,
            categorySum,
            categoryColors[category[i]]!,
          ),
        ],
      ));
    }

    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: rods,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Map<String, dynamic>>> groupedData = {};

    // Group data by date
    for (var record in solidsData) {
      if (record.date != null) {
        String? dateStr = record.date!.toLocal().toString().split(' ')[0];
        DateTime date = DateTime.parse(dateStr!);
        date = DateTime(date.year, date.month, date.day);
        groupedData[date] ??= [];
        groupedData[date]!.add(record.toJson());
      }
    }

    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 80,
            minY: 0,
            groupsSpace: 12,
            barTouchData: BarTouchData(
              handleBuiltInTouches: false,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                // Your touch callback logic...
              },
            ),
            titlesData: FlTitlesData(
                // Display dates on X-axis
                bottomTitles: AxisTitles(
                  drawBelowEverything: true,
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) {
                      // Convert double value to DateTime
                      DateTime date = groupedData.keys.toList()[value.toInt()];
                      // Format the date using Intl library
                      String formattedDate = DateFormat('MMM d').format(date);
                      // Return a Text widget with the formatted date
                      return Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false))),
            gridData: FlGridData(
                // Your grid data...
                ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: groupedData.entries
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    e.value.value,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
