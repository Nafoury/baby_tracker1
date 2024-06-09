import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BabyHeightChart extends StatelessWidget {
  final List<HeightMeasureData> heightmeasureRecords;
  final DateTime babyBirth;

  const BabyHeightChart(
      {required this.heightmeasureRecords, required this.babyBirth});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<HeightMeasureData>> monthlyData =
        _groupDataByMonth(heightmeasureRecords);

    // Combine all data into a single list, including placeholder entries for missing months
    final List<HeightMeasureData> allData =
        _createCompleteMonthlyData(monthlyData);

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
                DateTime(babyBirth.year, babyBirth.month, 1), // Minimum date
            maximum: DateTime(
                babyBirth.year + 1, babyBirth.month, 31), // Maximum date
            majorGridLines: MajorGridLines(width: 1), // Hide grid lines
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 20,
            interval: 5,
          ),
          series: <CartesianSeries>[
            ScatterSeries<HeightMeasureData, DateTime>(
              dataSource: allData,
              xValueMapper: (HeightMeasureData data, _) => data.date!,
              yValueMapper: (HeightMeasureData data, _) => data.measure,
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

  Map<DateTime, List<HeightMeasureData>> _groupDataByMonth(
      List<HeightMeasureData> data) {
    final Map<DateTime, List<HeightMeasureData>> groupedData = {};

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

  List<HeightMeasureData> _createCompleteMonthlyData(
      Map<DateTime, List<HeightMeasureData>> monthlyData) {
    final List<HeightMeasureData> allData = [];

    for (var month = 1; month <= 12; month++) {
      final monthStart = DateTime(DateTime.now().year, month, 1);
      final existingData = monthlyData[monthStart] ?? [];

      // Add existing data
      allData.addAll(existingData);
    }

    return allData;
  }
}
