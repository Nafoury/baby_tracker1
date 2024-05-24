import 'package:baba_tracker/common_widgets/roundCircle.dart';
import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/provider/bottleDataProvider.dart';
import 'package:baba_tracker/view/editionanddeletion/bottleData_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BottleDataTable extends StatelessWidget {
  final List<BottleData> bottleRecords;
  const BottleDataTable({super.key, required this.bottleRecords});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottleDataProvider>(
      builder: (context, bottleProvider, child) {
        List<BottleData> bottleRecords = bottleProvider.bottleRecords;
        if (bottleRecords.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 150),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/bottledata.png',
                    height: 90,
                    width: 90,
                  ),
                  Text("There's no bottle data available")
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Note',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(''),
            ),
          ],
          rows: bottleRecords.map((bottleRecord) {
            return DataRow(cells: [
              DataCell(
                Text(
                  DateFormat('dd MMM yy').format(bottleRecord.startDate!),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${bottleRecord.amount.toString()} ml',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              DataCell(
                bottleRecord.note.toString().isNotEmpty
                    ? RoundCircle()
                    : Text(
                        bottleRecord.note.toString(),
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
                        builder: (context) =>
                            BottleEdit(entryData: bottleRecord),
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
      },
    );
  }
}
