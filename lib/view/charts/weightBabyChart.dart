import 'package:baba_tracker/models/babyWeight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatelessWidget {
  final List<WeightData> weightRecords;
  final DateTime babyBirthDate;

  const WeightChart({required this.weightRecords, required this.babyBirthDate});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<WeightData>> monthlyData =
        _groupDataByMonth(weightRecords);

    // Combine all data into a single list, including placeholder entries for missing months
    final List<WeightData> allData = _createCompleteMonthlyData(monthlyData);

    return Center(
      child: Container(
        width: 350,
        height: 350,
        child: SfCartesianChart(
          legend: Legend(isVisible: false),
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.M(), // Format months as numbers
            interval: 1,
            minimum: DateTime(babyBirthDate.year, babyBirthDate.month, 1),
            maximum: DateTime(babyBirthDate.year + 1, babyBirthDate.month, 31),
            majorGridLines: MajorGridLines(width: 1),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 20,
            interval: 5,
          ),
          series: <CartesianSeries>[
            ScatterSeries<WeightData, DateTime>(
              dataSource: allData,
              xValueMapper: (WeightData data, _) => data.date!,
              yValueMapper: (WeightData data, _) => data.weight,
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

  Map<DateTime, List<WeightData>> _groupDataByMonth(List<WeightData> data) {
    final Map<DateTime, List<WeightData>> groupedData = {};

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

  List<WeightData> _createCompleteMonthlyData(
      Map<DateTime, List<WeightData>> monthlyData) {
    final List<WeightData> allData = [];

    DateTime startMonth = DateTime(babyBirthDate.year, babyBirthDate.month, 1);

    for (var i = 0; i < 12; i++) {
      final monthStart = DateTime(startMonth.year, startMonth.month + i, 1);
      final existingData = monthlyData[monthStart] ?? [];

      allData.addAll(existingData);
    }

    return allData;
  }
}
