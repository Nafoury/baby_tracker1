import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/models/diaperData.dart';

class DiaperChart extends StatelessWidget {
  final List<DiaperData> diaperRecords;
  const DiaperChart({required this.diaperRecords});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 6,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: generateBarGroups(),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          alignment: BarChartAlignment.spaceAround,
        ),
      ),
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    Map<String, double> totalAmounts = {};
    DateTime currentDate = DateTime.now();

    for (var i = 7; i >= 0; i--) {
      DateTime date = currentDate.subtract(Duration(days: i));
      String dateStr = date.toLocal().toString().split(' ')[0];

      // Initialize totalAmount for the date
      totalAmounts[dateStr] = 0.0;
    }

    for (var record in diaperRecords) {
      DiaperData diaperData = record;

      String dateStr = diaperData.startDate.toLocal().toString().split(' ')[0];
      if (totalAmounts.containsKey(dateStr)) {
        // Increment the totalAmount for the date
        totalAmounts[dateStr] = totalAmounts[dateStr]! + 1;
      }
    }

    List<BarChartGroupData> barGroups = totalAmounts.entries.map((entry) {
      return generateGroup(entry.key, entry.value);
    }).toList();

    return barGroups;
  }

  BarChartGroupData generateGroup(String date, double totalAmount) {
    return BarChartGroupData(
      x: DateTime.parse(date).millisecondsSinceEpoch.toInt(),
      barsSpace: 2,
      barRods: [
        BarChartRodData(
            toY: totalAmount,
            color: Colors.cyan.shade400,
            width: 18,
            borderRadius: BorderRadius.only()),
      ],
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
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
                date.day.toString() + '\n' + _getMonthAbbreviation(date.month),
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
            interval: 1,
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

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}
