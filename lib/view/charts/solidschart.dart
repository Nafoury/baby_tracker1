import 'package:baba_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SolidsChart extends StatefulWidget {
  final List<SolidsData> solidsRecords;
  const SolidsChart({Key? key, required this.solidsRecords}) : super(key: key);

  @override
  _SolidsChartState createState() => _SolidsChartState();
}

class _SolidsChartState extends State<SolidsChart> {
  late List<String> labels;
  late List<DateTime> dates;
  late List<SolidsData> mappedData;
  late double maxY;
  late DateTime selectedStartDate;

  @override
  void initState() {
    super.initState();
    selectedStartDate =
        DateTime.now().subtract(Duration(days: 6)); // Include today
    updateChartData(selectedStartDate);
  }

  void updateChartData(DateTime startDate) {
    labels = [];
    dates = [];
    mappedData = [];
    maxY = 0;

    for (var i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      dates.add(date);
      String dateStr = date.toLocal().toString().split(' ')[0];
      labels.add('${date.day}.${date.month}');
    }

    for (var date in dates) {
      SolidsData? dataForDate = widget.solidsRecords.firstWhere(
        (data) => data.date!.day == date.day && data.date!.month == date.month,
        orElse: () => SolidsData(
          date: date,
          fruits: 0,
          veg: 0,
          protein: 0,
          grains: 0,
          dairy: 0,
        ),
      );
      mappedData.add(dataForDate);
    }

    maxY = calculateMaxY();

    // Debugging print statements
    print("Mapped Data: $mappedData");
    print("Max Y: $maxY");
    print("Labels: $labels");

    setState(() {});
  }

  double calculateMaxY() {
    int maxAmount = 0;

    for (var record in widget.solidsRecords) {
      int totalAmount = record.fruits! +
          record.veg! +
          record.grains! +
          record.dairy! +
          record.protein!;
      if (totalAmount > maxAmount) {
        maxAmount = totalAmount;
      }
    }

    // You can add some padding to the maxY value if needed
    return maxAmount + 50;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Overview",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedStartDate =
                      selectedStartDate.subtract(Duration(days: 7));
                  updateChartData(selectedStartDate);
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
                  selectedStartDate = selectedStartDate.add(Duration(days: 7));
                  updateChartData(selectedStartDate);
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
          height: 350,
          width: 500,
          child: SfCartesianChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(),
              majorGridLines: MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 1,
              labelPlacement: LabelPlacement.onTicks,
              arrangeByIndex: false,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: maxY,
              interval: 50,
            ),
            series: [
              StackedColumnSeries<SolidsData, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    '${data.date!.day}.${data.date!.month}',
                yValueMapper: (data, _) => data.fruits,
                name: 'Fruits',
                color: Colors.pink.shade100,
              ),
              StackedColumnSeries<SolidsData, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    '${data.date!.day}.${data.date!.month}',
                yValueMapper: (data, _) => data.veg,
                name: 'Vegetables',
                color: Colors.green.shade200,
              ),
              StackedColumnSeries<SolidsData, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    '${data.date!.day}.${data.date!.month}',
                yValueMapper: (data, _) => data.protein,
                name: 'Protein',
                color: Colors.brown.shade200,
              ),
              StackedColumnSeries<SolidsData, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    '${data.date!.day}.${data.date!.month}',
                yValueMapper: (data, _) => data.grains,
                name: 'Grains',
                color: Colors.blue.shade100,
              ),
              StackedColumnSeries<SolidsData, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    '${data.date!.day}.${data.date!.month}',
                yValueMapper: (data, _) => data.dairy,
                name: 'Dairy',
                color: Colors.blue.shade500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
