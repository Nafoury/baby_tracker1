import 'package:baby_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolidsChart extends StatelessWidget {
  final List<SolidsData> solidsRecords;
  const SolidsChart({Key? key, required this.solidsRecords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate the labels for the last seven days
    DateTime currentDate = DateTime.now();
    for (var i = 7; i >= 0; i--) {
      DateTime date = currentDate.subtract(Duration(days: i));
      String dateStr = date.toLocal().toString().split(' ')[0];
    }

    return Container(
      height: 350,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(),
        ),
        series: [
          StackedColumnSeries<SolidsData, String>(
            dataSource: solidsRecords,
            xValueMapper: (data, _) => '${data.date!.day}.${data.date!.month}',
            yValueMapper: (data, _) => data.fruits,
            name: 'Fruits',
            color: Colors.pink.shade100,
          ),
          StackedColumnSeries<SolidsData, String>(
            dataSource: solidsRecords,
            xValueMapper: (data, _) => '${data.date!.day}.${data.date!.month}',
            yValueMapper: (data, _) => data.veg,
            name: 'Vegetables',
            color: Colors.green.shade200,
          ),
          StackedColumnSeries<SolidsData, String>(
            dataSource: solidsRecords,
            xValueMapper: (data, _) => '${data.date!.day}.${data.date!.month}',
            yValueMapper: (data, _) => data.protein,
            name: 'Protein',
            color: Colors.brown.shade200,
          ),
          StackedColumnSeries<SolidsData, String>(
            dataSource: solidsRecords,
            xValueMapper: (data, _) => '${data.date!.day}.${data.date!.month}',
            yValueMapper: (data, _) => data.grains,
            name: 'Grains',
            color: Colors.blue.shade100,
          ),
          StackedColumnSeries<SolidsData, String>(
            dataSource: solidsRecords,
            xValueMapper: (data, _) => '${data.date!.day}.${data.date!.month}',
            yValueMapper: (data, _) => data.dairy,
            name: 'Dairy',
            color: Colors.blue.shade500,
          ),
        ],
      ),
    );
  }
}
