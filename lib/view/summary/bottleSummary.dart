import 'package:baby_tracker/models/bottleData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottleSummaryTable extends StatelessWidget {
  final List<BottleData> bottleRecords;

  BottleSummaryTable({required this.bottleRecords});

  @override
  Widget build(BuildContext context) {
    // Group records by date
    Map<String, double> totalLiquidAmounts = {};

    for (var record in bottleRecords) {
      String? dateStr = record.startDate?.toLocal().toString().split(' ')[0];
      if (dateStr != null) {
        totalLiquidAmounts[dateStr] ??= 0.0;
        totalLiquidAmounts[dateStr] =
            (record.amount ?? 0.0) + totalLiquidAmounts[dateStr]!;
      }
    }

    print("Total Liquid Amounts: $totalLiquidAmounts"); // Print to check data

    // Build summary rows
    List<DataRow> summaryRows = [];

    totalLiquidAmounts.forEach((date, totalLiquidAmount) {
      summaryRows.add(DataRow(
        cells: [
          DataCell(Text(date)),
          DataCell(Text(totalLiquidAmount.toString())),
        ],
      ));
    });

    print("Summary Rows: $summaryRows"); // Print to check if rows are built

    return DataTable(
      columns: [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Total Liquid')),
      ],
      rows: summaryRows,
    );
  }
}
