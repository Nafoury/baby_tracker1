import 'package:baba_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SolidsChart extends StatefulWidget {
  final List<SolidsData> solidsRecords;
  const SolidsChart({Key? key, required this.solidsRecords}) : super(key: key);

  @override
  _SolidsChartState createState() => _SolidsChartState();
}

class _SolidsChartState extends State<SolidsChart> {
  late List<String> labels;
  late List<DateTime> dates;
  late List<SolidsData?> mappedData; // Changed to nullable
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
      labels.add('${date.day}.${date.month}');
    }

    for (var date in dates) {
      SolidsData? dataForDate = widget.solidsRecords.firstWhere(
        (data) => data.date!.day == date.day && data.date!.month == date.month,
        orElse: () => SolidsData(
          date: date,
          fruits: null,
          veg: null,
          protein: null,
          grains: null,
          dairy: null,
        ),
      );
      if (dataForDate.fruits != null ||
          dataForDate.veg != null ||
          dataForDate.protein != null ||
          dataForDate.grains != null ||
          dataForDate.dairy != null) {
        mappedData.add(dataForDate);
      }
    }

    maxY = calculateMaxY();

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
          children: [
            Text(
              DateFormat('MMM dd -')
                  .format(selectedStartDate.subtract(Duration(days: 6))),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              DateFormat('MMM dd, yyyy')
                  .format(selectedStartDate.add(Duration(days: 6))),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
              StackedColumnSeries<SolidsData?, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    data != null ? '${data.date!.day}.${data.date!.month}' : '',
                yValueMapper: (data, _) => data != null ? data.fruits : null,
                name: 'Fruits',
                color: Colors.pink.shade100,
              ),
              StackedColumnSeries<SolidsData?, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    data != null ? '${data.date!.day}.${data.date!.month}' : '',
                yValueMapper: (data, _) => data != null ? data.veg : null,
                name: 'Vegetables',
                color: Colors.green.shade200,
              ),
              StackedColumnSeries<SolidsData?, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    data != null ? '${data.date!.day}.${data.date!.month}' : '',
                yValueMapper: (data, _) => data != null ? data.protein : null,
                name: 'Protein',
                color: Colors.brown.shade200,
              ),
              StackedColumnSeries<SolidsData?, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    data != null ? '${data.date!.day}.${data.date!.month}' : '',
                yValueMapper: (data, _) => data != null ? data.grains : null,
                name: 'Grains',
                color: Colors.blue.shade100,
              ),
              StackedColumnSeries<SolidsData?, String>(
                dataSource: mappedData,
                xValueMapper: (data, _) =>
                    data != null ? '${data.date!.day}.${data.date!.month}' : '',
                yValueMapper: (data, _) => data != null ? data.dairy : null,
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
