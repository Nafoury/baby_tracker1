import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GrowthSummaryTable extends StatelessWidget {
  final List<HeightMeasureData> heightRecords;
  final List<MeasureData> headRecords;
  final List<WeightData> weightRecords;

  GrowthSummaryTable({
    required this.heightRecords,
    required this.headRecords,
    required this.weightRecords,
  });

  @override
  Widget build(BuildContext context) {
    // Group records by date
    Map<String, double> heightRecord = {};
    Map<String, double> headRecord = {};
    Map<String, double> weightRecord = {};

    for (var record in heightRecords) {
      String dateStr = DateFormat('yy-MM-dd').format(record.date!);
      heightRecord[dateStr] = record.measure!;
    }

    for (var record in headRecords) {
      String dateStr = DateFormat('yy-MM-dd').format(record.date!);
      headRecord[dateStr] = record.measure!;
    }

    for (var record in weightRecords) {
      String dateStr = DateFormat('yy-MM-dd').format(record.date!);
      weightRecord[dateStr] = record.weight!;
    }

    Set<String> allDates = {
      ...heightRecord.keys,
      ...headRecord.keys,
      ...weightRecord.keys,
    };

    // Build summary rows
    List<DataRow> summaryRows = allDates.map((dateStr) {
      DateTime date = DateFormat('yy-MM-dd').parse(dateStr);
      String formattedDate = DateFormat('dd MMM yy').format(date);

      return DataRow(
        cells: [
          DataCell(Padding(
              padding: EdgeInsets.only(right: 35), child: Text(formattedDate))),
          DataCell(Text((weightRecord[dateStr] ?? 0.0).toString() + 'kg')),
          DataCell(Text((headRecord[dateStr] ?? 0.0).toString() + ' cm')),
          DataCell(Text((heightRecord[dateStr] ?? 0.0).toString() + ' cm')),
        ],
      );
    }).toList();

    return Container(
      width:
          MediaQuery.of(context).size.width, // Set the width of the container
      child: DataTable(
        columnSpacing: 11.0, // Set the space between columns
        columns: [
          DataColumn(
              label: Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          )),
          DataColumn(
              label: Text(
            'Weight',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          DataColumn(
              label: Text(
            'Head',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          DataColumn(
              label: Text(
            'Height',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
        ],
        rows: summaryRows,
      ),
    );
  }
}
