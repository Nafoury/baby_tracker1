import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedingSummaryTable extends StatelessWidget {
  final List<BottleData> bottleRecords;
  final List<SolidsData> solidsRecrods;

  FeedingSummaryTable(
      {required this.bottleRecords, required this.solidsRecrods});

  @override
  Widget build(BuildContext context) {
    // Group records by date
    Map<String, double> totalLiquidAmounts = {};
    Map<String, int> totalSolidsAmounts = {};

    for (var record in bottleRecords) {
      String? dateStr = record.startDate?.toLocal().toString().split(' ')[0];
      if (dateStr != null) {
        totalLiquidAmounts[dateStr] ??= 0.0;
        totalLiquidAmounts[dateStr] =
            (totalLiquidAmounts[dateStr] ?? 0.0) + (record.amount ?? 0.0);
      }
    }
    for (var record in solidsRecrods) {
      String? dateStr = record.date?.toLocal().toString().split(' ')[0];
      dateStr = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateStr!));
      totalSolidsAmounts[dateStr] ??= 0;
      totalSolidsAmounts[dateStr] = (totalSolidsAmounts[dateStr] ?? 0) +
          ((record.dairy ?? 0).toDouble() +
                  (record.fruits ?? 0).toDouble() +
                  (record.grains ?? 0).toDouble() +
                  (record.protein ?? 0).toDouble())
              .toInt();
    }

    print("Total Liquid Amounts: $totalLiquidAmounts");
    print("Total Solids Amounts: $totalSolidsAmounts");

    Set<String> allDates = {
      ...totalLiquidAmounts.keys,
      ...totalSolidsAmounts.keys
    };

// Build summary rows
    List<DataRow> summaryRows = allDates.map((dateStr) {
      DateTime date = DateFormat('yy-MM-dd').parse(dateStr);
      String formattedDate = DateFormat('dd MMM yy').format(date);

      return DataRow(
        cells: [
          DataCell(Text(formattedDate)),
          DataCell(
              Text((totalLiquidAmounts[dateStr] ?? 0.0).toString() + 'ml')),
          DataCell(Text((totalSolidsAmounts[dateStr] ?? 0).toString() + 'g')),
        ],
      );
    }).toList();

    return DataTable(
      columns: [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Liquid')),
        DataColumn(label: Text('Solids')),
      ],
      rows: summaryRows,
    );
  }
}
