import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/models/diaperData.dart';

class DiaperChart extends StatefulWidget {
  final List<DiaperData> diaperRecords;
  const DiaperChart({required this.diaperRecords});

  @override
  _DiaperChartState createState() => _DiaperChartState();
}

class _DiaperChartState extends State<DiaperChart> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentDate = currentDate.subtract(Duration(days: 7));
                });
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (currentDate.isBefore(DateTime.now())) {
                    currentDate = currentDate.add(Duration(days: 7));
                  }
                });
              },
              icon: Icon(
                Icons.arrow_forward,
                size: 20,
              ),
            ),
          ],
        ),
        Container(
          height: 250,
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
        ),
      ],
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    Map<String, double> totalAmounts = {};

    // Calculate the start and end date for the current week
    DateTime startDate =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));

    // Initialize totalAmount for each day of the current week
    for (var i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      String dateStr = date.toLocal().toString().split(' ')[0];
      totalAmounts[dateStr] = 0.0;
    }

    // Update totalAmounts based on diaperRecords
    for (var record in widget.diaperRecords) {
      DiaperData diaperData = record;
      String dateStr = diaperData.startDate.toLocal().toString().split(' ')[0];
      if (totalAmounts.containsKey(dateStr)) {
        totalAmounts[dateStr] = totalAmounts[dateStr]! + 1;
      }
    }

    // Generate BarChartGroupData for each day of the current week
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
          borderRadius: BorderRadius.only(),
        ),
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
