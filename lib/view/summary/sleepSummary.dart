import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepSummaryTable extends StatelessWidget {
  final List<SleepData>? sleepRecords;

  SleepSummaryTable({this.sleepRecords});

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  @override
  Widget build(BuildContext context) {
    if (sleepRecords == null || sleepRecords!.isEmpty) {
      return Center(child: Text("No data available."));
    }

    Map<String, int> totalDuration = {};

    for (var record in sleepRecords!) {
      if (record.startDate != null && record.endDate != null) {
        DateTime startDate = record.startDate!;
        DateTime endDate = record.endDate!;

        while (startDate.isBefore(endDate)) {
          DateTime nextDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day + 1,
          );

          // Calculate the duration for the current day
          int durationForDay = DateTime(
            startDate.year,
            startDate.month,
            startDate.day + 1,
          ).isBefore(endDate)
              ? nextDate.difference(startDate).inSeconds
              : endDate.difference(startDate).inSeconds;

          String dateStr = DateFormat('yyyy-MM-dd').format(startDate);
          totalDuration[dateStr] ??= 0;

          totalDuration[dateStr] =
              (totalDuration[dateStr] ?? 0) + (durationForDay);

          // Move to the next day
          startDate = nextDate;
        }
      }
    }

    Set<String> allDates = {
      ...totalDuration.keys,
    };

    List<DataRow> summaryRows = allDates.map((dateStr) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      String formattedDate = DateFormat('dd MMM yy').format(date);

      int durationInSeconds = totalDuration[dateStr] ?? 0;
      String formattedDuration = formatDuration(durationInSeconds);

      return DataRow(
        cells: [
          DataCell(
            Text(
              formattedDate,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600),
            ),
          ),
          DataCell(Text(
            formattedDuration,
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600),
          )),
        ],
      );
    }).toList();

    return Container(
      child: DataTable(
        columns: [
          DataColumn(
              label: Text(
            'Date',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          )),
          DataColumn(
              label: Text(
            'Total Sleep',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          )),
        ],
        rows: summaryRows,
      ),
    );
  }
}
