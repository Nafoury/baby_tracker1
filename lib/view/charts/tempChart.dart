import 'package:baby_tracker/models/tempData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TempChart extends StatefulWidget {
  final List<TempData> tempRecords;
  const TempChart({Key? key, required this.tempRecords}) : super(key: key);

  @override
  _TempChartState createState() => _TempChartState();
}

class _TempChartState extends State<TempChart> {
  late List<TempData> chartData;
  late DateTime selectedDate;
  late int daysOffset;

  @override
  void initState() {
    super.initState();
    daysOffset = 0; // Start with today's data
    selectedDate = DateTime.now();
    chartData = getChartData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMM dd, yyyy').format(selectedDate),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  daysOffset--;
                  selectedDate = DateTime.now().add(Duration(days: daysOffset));
                  chartData = getChartData(selectedDate);
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
                  if (daysOffset < 0) {
                    daysOffset++;
                    selectedDate =
                        DateTime.now().add(Duration(days: daysOffset));
                    chartData = getChartData(selectedDate);
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
          height: 400,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.Hm(),
              intervalType: DateTimeIntervalType.hours,
              interval: 2,
              minimum: DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day),
              maximum: DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, 23, 59),
            ),
            primaryYAxis: NumericAxis(
              minimum: 37,
              maximum: 42,
              interval: 1,
            ),
            series: <CartesianSeries>[
              ScatterSeries<TempData, DateTime>(
                dataSource: chartData,
                xValueMapper: (TempData temp, _) => temp.date!,
                yValueMapper: (TempData temp, _) => temp.temp!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<TempData> getChartData(DateTime date) {
    List<TempData> filteredData = [];
    widget.tempRecords.forEach((tempData) {
      if (tempData.date!.year == date.year &&
          tempData.date!.month == date.month &&
          tempData.date!.day == date.day) {
        filteredData.add(TempData(
          date: tempData.date,
          temp: convertTheTemp(tempData.temp!),
        ));
      }
    });
    return filteredData;
  }

  // Function to convert temperature
  double convertTheTemp(double temp) {
    return (temp * 5) + 37.0;
  }
}
