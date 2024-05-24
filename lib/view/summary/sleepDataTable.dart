import 'package:baba_tracker/common_widgets/roundCircle.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/view/editionanddeletion/sleep_edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepDataTable extends StatelessWidget {
  final List<SleepData> sleepRecords;
  const SleepDataTable({super.key, required this.sleepRecords});

  @override
  Widget build(BuildContext context) {
    if (sleepRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/pillow.png',
                height: 90,
                width: 90,
              ),
              Text("There's no sleep data available")
            ],
          ),
        ),
      );
    }
    return DataTable(
      columnSpacing: 22,
      columns: [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            'duration',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            'Note',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            '',
          ),
        ),
      ],
      rows: sleepRecords.map((record) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(record.startDate!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          DataCell(Text(
            _parseDuration(record.duration.toString()),
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13),
          )),
          DataCell(
            record.note.toString().isNotEmpty
                ? RoundCircle()
                : Text(
                    record.note.toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                  ),
          ),

          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SleepEdit(
                      entryData: record,
                    ),
                  ),
                );
              },
              icon: Image.asset(
                "assets/images/arroNext.png",
                width: 20,
                height: 20,
                fit: BoxFit.fitHeight,
              ),
            ),
          ), // Icon column
        ]);
      }).toList(),
    );
  }

  String _parseDuration(String durationString) {
    print(durationString);
    int totalMinutes = int.parse(durationString);

    // Calculate hours, minutes, and seconds
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    int seconds = 0; // For simplicity, assuming seconds are always 0

    // Formatting hours, minutes, and seconds to ensure they are displayed with leading zeros if necessary
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}
