import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BarChartSample5 extends StatelessWidget {
  final List<Map<String, dynamic>> solidsData;

  const BarChartSample5({Key? key, required this.solidsData}) : super(key: key);

  static const double barWidth = 22;

  BarChartGroupData generateGroup(
      int x, DateTime date, List<Map<String, dynamic>> data) {
    final Map<String, Color> categoryColors = {
      'fruits': Colors.pink,
      'veg': Colors.green,
      'protein': Colors.brown.shade200,
      'grains': Colors.blue.shade100,
      'dairy': Colors.black,
    };

    final List<BarChartRodData> rods = [];
    double sum = 0;

    final category = ['fruits', 'veg', 'protein', 'grains', 'dairy'];
    for (int i = 0; i < 5; i++) {
      double categoryValue = 0.0;

      // Iterate over the data and accumulate values for the current category
      for (var item in data) {
        categoryValue += item[category[i]].toDouble();
      }

      sum += categoryValue;

      rods.add(BarChartRodData(
        toY: sum,
        width: barWidth,
        borderRadius: BorderRadius.circular(7),
        rodStackItems: [
          BarChartRodStackItem(
            0,
            categoryValue,
            categoryColors[
                category[i]]!, // Use the corresponding color for the category
          ),
        ],
      ));
    }

    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: [],
      barRods: rods,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> totalAmounts = {};
    DateTime currentDate = DateTime.now();

    for (var i = 7; i >= 0; i--) {
      DateTime date = currentDate.subtract(Duration(days: i));
      String dateStr = date.toLocal().toString().split(' ')[0];

      // Initialize totalAmount for the date
      totalAmounts[dateStr] = 0.0;
    }

    return AspectRatio(
      aspectRatio: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 13),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 80,
            minY: 0,
            groupsSpace: 12,
            titlesData: FlTitlesData(
              // Display dates on X-axis
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
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
                  interval: 20,
                  reservedSize: 40,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (value) => value % 20 == 0,
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: totalAmounts.keys
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    DateTime.parse(e.value),
                    solidsData
                        .where((data) =>
                            DateFormat('yyyy-MM-dd').format(data['date']) ==
                            e.value)
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
