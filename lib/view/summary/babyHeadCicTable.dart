import 'package:baby_tracker/models/babyHead.dart';
import 'package:baby_tracker/models/babyWeight.dart';
import 'package:baby_tracker/view/editionanddeletion/babyHeadEdit_Deletion.dart';
import 'package:baby_tracker/view/editionanddeletion/babyWeight_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyHeadDataTable extends StatelessWidget {
  final List<MeasureData> measureRecords;
  const BabyHeadDataTable({super.key, required this.measureRecords});

  @override
  Widget build(BuildContext context) {
    if (measureRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/measure.png',
                height: 90,
                width: 90,
              ),
              Text("There's no weight data available")
            ],
          ),
        ),
      );
    }
    return DataTable(
      columnSpacing: 45,
      columns: [
        DataColumn(
            label: Text(
              'Date',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            numeric: true),
        DataColumn(
            label: Text(
              'Measure',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            numeric: true),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontSize: 3),
          ),
        ),
      ],
      rows: measureRecords.map((records) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(records.date!),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),

          DataCell(Text(
            '${records.measure.toString()} cm',
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13),
          )),

          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BabyHeadEdit(
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
          ), // Icon column
        ]);
      }).toList(),
    );
  }
}
