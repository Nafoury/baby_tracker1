import 'package:baba_tracker/common_widgets/roundCircle.dart';
import 'package:baba_tracker/models/vaccineData.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
import 'package:baba_tracker/view/editionanddeletion/vaccine_edition_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VaccineRecordsTable extends StatelessWidget {
  final List<VaccineData> vaccineRecords;
  const VaccineRecordsTable({super.key, required this.vaccineRecords});

  @override
  Widget build(BuildContext context) {
    if (vaccineRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 90),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/injection.png',
                height: 90,
                width: 90,
              ),
              Text("There's no vaccine data available")
            ],
          ),
        ),
      );
    }

    return DataTable(
      columnSpacing: 30,
      columns: [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            'Type',
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
      rows: vaccineRecords.map((records) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(records.date!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataCell(Text(
            '${records.type.toString().substring(0, records.type.toString().indexOf('(')).trim()}', // Displaying only the first 10 characters
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13),
          )),
          DataCell(
            records.note.toString().isNotEmpty
                ? RoundCircle()
                : Text(
                    records.note.toString(),
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
                    builder: (context) => VaccineEdit(
                      entryData: records,
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
          ),
        ]);
      }).toList(),
    );
  }
}
