import 'package:baba_tracker/models/babyHead.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeadChart extends StatelessWidget {
  final List<MeasureData> measureRecords;
  final DateTime babybirth;

  const HeadChart({required this.measureRecords, required this.babybirth});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<MeasureData>> monthlyData =
        _groupDataByMonth(measureRecords);

    // Combine all data into a single list, including placeholder entries for missing months
    final List<MeasureData> allData = _createCompleteMonthlyData(monthlyData);

    return Center(
      child: Container(
        width: 350,
        height: 350,
        child: SfCartesianChart(
          legend: Legend(isVisible: false),
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.M(),
            interval: 1,
            minimum:
                DateTime(babybirth.year, babybirth.month, 1), // Minimum date
            maximum: DateTime(
                babybirth.year + 1, babybirth.month, 31), // Maximum date
            majorGridLines: MajorGridLines(width: 1), // Hide grid lines
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 20,
            interval: 5,
          ),
          series: <CartesianSeries>[
            ScatterSeries<MeasureData, DateTime>(
              dataSource: allData,
              xValueMapper: (MeasureData data, _) => data.date!,
              yValueMapper: (MeasureData data, _) => data.measure,
              markerSettings: MarkerSettings(
                isVisible: true,
                height: 8,
                width: 8,
                shape: DataMarkerType.circle,
                color: Colors.blue,
              ),
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<MeasureData>> _groupDataByMonth(List<MeasureData> data) {
    final Map<DateTime, List<MeasureData>> groupedData = {};

    // Populate the lists with actual data
    for (var record in data) {
      final monthStart = DateTime(record.date!.year, record.date!.month, 1);
      groupedData.update(
        monthStart,
        (existingData) => [...existingData, record],
        ifAbsent: () => [record],
      );
    }

    return groupedData;
  }

  // Create a complete list of WeightData objects with placeholders for missing months
  List<MeasureData> _createCompleteMonthlyData(
      Map<DateTime, List<MeasureData>> monthlyData) {
    final List<MeasureData> allData = [];

    DateTime startMonth = DateTime(babybirth.year, babybirth.month, 1);

    for (var i = 0; i < 12; i++) {
      final monthStart = DateTime(startMonth.year, startMonth.month + i, 1);
      final existingData = monthlyData[monthStart] ?? [];

      allData.addAll(existingData);
    }

    return allData;
  }
}
