import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedingSummaryTable extends StatelessWidget {
  final List<BottleData> bottleRecords;
  final List<SolidsData> solidsRecrods;
  final List<NusringData> nursingRecords;

  FeedingSummaryTable({
    required this.bottleRecords,
    required this.solidsRecrods,
    required this.nursingRecords,
  });

  @override
  Widget build(BuildContext context) {
    // Group records by date
    Map<String, double> totalLiquidAmounts = {};
    Map<String, int> totalSolidsAmounts = {};
    Map<String, Duration> totalNursingAmounts = {};

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
                  (record.protein ?? 0).toDouble() +
                  (record.veg ?? 0).toDouble())
              .toInt();
    }
    for (var record in nursingRecords) {
      String? dateStr = record.date?.toLocal().toString().split(' ')[0];
      dateStr = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateStr!));
      totalNursingAmounts[dateStr] ??= Duration.zero;

      // Check if leftDuration is not null before parsing
      Duration leftDuration = record.leftDuration != null
          ? _parseDuration(record.leftDuration!)
          : Duration.zero;

      // Check if rightDuration is not null before parsing
      Duration rightDuration = record.rightDuration != null
          ? _parseDuration(record.rightDuration!)
          : Duration.zero;

      // Add the durations together
      totalNursingAmounts[dateStr] =
          (totalNursingAmounts[dateStr] ?? Duration.zero) +
              leftDuration +
              rightDuration;
    }

    print("Total Liquid Amounts: $totalLiquidAmounts");
    print("Total Solids Amounts: $totalSolidsAmounts");
    print("Total Nursing Durations: $totalNursingAmounts");

    Set<String> allDates = {
      ...totalLiquidAmounts.keys,
      ...totalSolidsAmounts.keys,
      ...totalNursingAmounts.keys,
    };

    // Build summary rows
    List<DataRow> summaryRows = allDates.map((dateStr) {
      DateTime date = DateFormat('yy-MM-dd').parse(dateStr);
      String formattedDate = DateFormat('dd MMM yy').format(date);

      return DataRow(
        cells: [
          DataCell(Padding(
              padding: EdgeInsets.only(right: 35), child: Text(formattedDate))),
          DataCell(
              Text((totalLiquidAmounts[dateStr] ?? 0.0).toString() + 'ml')),
          DataCell(Text((totalSolidsAmounts[dateStr] ?? 0).toString() + 'g')),
          DataCell(Text(_formatDuration(totalNursingAmounts[dateStr]))),
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
            'Liquid',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          DataColumn(
              label: Text(
            'Solids',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          DataColumn(
              label: Text(
            'Nursing',
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
        ],
        rows: summaryRows,
      ),
    );
  }

  Duration _parseDuration(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    return '${duration.inMinutes}m${(duration.inSeconds % 60).toString().padLeft(1, '0')}s';
  }
}
