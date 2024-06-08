import 'package:baba_tracker/models/babyWeight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatelessWidget {
  final List<WeightData> weightRecords;

  const WeightChart({required this.weightRecords});

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
            dateFormat: DateFormat.M(),
            interval: 1,
            minimum: DateTime(DateTime.now().year, 1, 1), // Minimum date
            maximum: DateTime(DateTime.now().year, 12, 31), // Maximum date
            majorGridLines: MajorGridLines(width: 1), // Hide grid lines
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

    // Populate the lists with actual data
    for (var record in data) {
      final monthStart = DateTime(record.date!.year, record.date!.month,
          1); //detrmine the start of month
      groupedData.update(
        monthStart,
        (existingData) => [...existingData, record], //lambda function
        ifAbsent: () => [record],
      ); // if month start alreday exists update it with the weight record other wise create one
    }

    return groupedData;
  }

  // Create a complete list of WeightData objects with placeholders for missing months
  List<WeightData> _createCompleteMonthlyData(
      Map<DateTime, List<WeightData>> monthlyData) {
    final List<WeightData> allData = [];

    for (var month = 1; month <= 12; month++) {
      final monthStart = DateTime(DateTime.now().year, month, 1);
      final existingData = monthlyData[monthStart] ?? [];

      // Add existing data
      allData.addAll(existingData);
    }

    return allData;
  }
}
