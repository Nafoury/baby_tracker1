import 'package:baba_tracker/common_widgets/roundCircle.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/provider/diaper_provider.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/view/editionanddeletion/diaper_edit.dart';
import 'package:baba_tracker/view/editionanddeletion/med_edition_deletion.dart';
import 'package:baba_tracker/view/home/diaper_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DiaperDataTable extends StatefulWidget {
  const DiaperDataTable({Key? key}) : super(key: key);

  @override
  State<DiaperDataTable> createState() => _DiaperDataTableState();
}

class _DiaperDataTableState extends State<DiaperDataTable> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DiaperProvider>(
      builder: (context, diaperProvider, child) {
        List<DiaperData> diaperRecords = diaperProvider.diaperRecords;
        if (diaperRecords.isEmpty) {
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
                'Type',
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
          rows: diaperRecords.map((diaperRecord) {
            return DataRow(cells: [
              DataCell(
                Text(
                  DateFormat('dd MMM yy').format(diaperRecord.startDate),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  diaperRecord.status.toString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              DataCell(
                diaperRecord.note.toString().isNotEmpty
                    ? RoundCircle()
                    : Text(
                        diaperRecord.note.toString(),
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
                            DiaperEdit(entryData: diaperRecord),
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
