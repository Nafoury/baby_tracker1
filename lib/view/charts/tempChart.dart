import 'package:baby_tracker/models/tempData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TempChart extends StatelessWidget {
  final List<TempData> tempRecords;
  const TempChart({Key? key, required this.tempRecords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TempData> chartData = [];
    TempData tempData;
    late DateTime selectedDate;

    // Convert temperature data
    tempRecords.forEach((tempData) {
      chartData.add(TempData(
        date: tempData.date,
        temp: convertTheTemp(tempData.temp!),
      ));
    });

    // Get the minimum and maximum date from data for adjusting axis range
    DateTime minDate = chartData.isNotEmpty
        ? chartData
            .map((data) => data.date!)
            .reduce((a, b) => a.isBefore(b) ? a : b)
        : DateTime.now();
    DateTime maxDate = chartData.isNotEmpty
        ? chartData
            .map((data) => data.date!)
            .reduce((a, b) => a.isAfter(b) ? a : b)
        : DateTime.now();

    // Adjust the axis range to include all data points
    double hourInterval = 2;
    DateTimeAxis primaryXAxis = DateTimeAxis(
      dateFormat: DateFormat.Hm(),
      intervalType: DateTimeIntervalType.hours,
      interval: hourInterval,
      minimum: DateTime(minDate.year, minDate.month, minDate.day),
      maximum: DateTime(maxDate.year, maxDate.month, maxDate.day, 23, 59),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 400,
        child: SfCartesianChart(
          primaryXAxis: primaryXAxis,
          primaryYAxis: NumericAxis(
            minimum: 37,
            maximum: 42,
            interval: 1,
          ),
          series: <CartesianSeries>[
            ScatterSeries<TempData, DateTime>(
              dataSource: chartData,
              xValueMapper: (TempData temp, _) => temp.date,
              yValueMapper: (TempData temp, _) => temp.temp,
            ),
          ],
        ),
      ),
    ]);
  }

  // Function to convert temperature
  double convertTheTemp(double temp) {
    return (temp * 5) + 37.0;
  }
}
