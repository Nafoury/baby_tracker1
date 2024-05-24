import 'package:baba_tracker/common_widgets/roundCircle.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/provider/nursingDataProvider.dart';
import 'package:baba_tracker/view/editionanddeletion/nursing_edition_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NursingDataTable extends StatefulWidget {
  final List<NusringData> nursingRecords;
  const NursingDataTable({super.key, required this.nursingRecords});

  @override
  State<NursingDataTable> createState() => _NursingDataTableState();
}

class _NursingDataTableState extends State<NursingDataTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NursingDataProvider>(
      builder: (context, nursingProvider, child) {
        List<NusringData> nursingRecords = nursingProvider.nursingRecords;
        if (nursingRecords == null || nursingRecords!.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 150),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/diaper.png',
                    height: 90,
                    width: 90,
                  ),
                  Text("There's no diaper data available")
                ],
              ),
            ),
          );
        }
        return DataTable(
          columnSpacing: 19,
          columns: [
            DataColumn(
              label: Text(
                'Date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Duration',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Breast',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(''),
            ),
          ],
          rows: nursingRecords.map((nursingRecord) {
            return DataRow(cells: [
              DataCell(
                Text(
                  DateFormat('dd MMM yy').format(nursingRecord.date!),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _parseDuration(nursingRecord.leftDuration.toString(),
                      nursingRecord.rightDuration.toString()),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              DataCell(
                Text(
                  nursingRecord.nursingSide.toString() +
                      nursingRecord.startingBreast.toString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NursingEditAndDeletion(
                                entryData: nursingRecord,
                              )),
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
      },
    );
  }

  String _parseDuration(String leftDurationStr, String rightDurationStr) {
    Duration leftDuration = Duration(); // Initialize to zero
    Duration rightDuration = Duration(); // Initialize to zero

    // Parse leftDurationStr and rightDurationStr into Duration objects
    if (leftDurationStr.isNotEmpty) {
      leftDuration = Duration(
        hours: int.parse(leftDurationStr.split(':')[0]),
        minutes: int.parse(leftDurationStr.split(':')[1]),
        seconds: int.parse(leftDurationStr.split(':')[2]),
      );
    }
    if (rightDurationStr.isNotEmpty) {
      rightDuration = Duration(
        hours: int.parse(rightDurationStr.split(':')[0]),
        minutes: int.parse(rightDurationStr.split(':')[1]),
        seconds: int.parse(rightDurationStr.split(':')[2]),
      );
    }

    // Add the durations together
    Duration totalNursingAmounts = leftDuration + rightDuration;

    // Convert totalNursingAmounts to the format "hh:mm:ss"
    String formattedDuration =
        totalNursingAmounts.toString().split('.').first.padLeft(8, '0');

    return formattedDuration;
  }
}
