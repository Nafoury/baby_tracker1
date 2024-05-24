import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/view/editionanddeletion/babyHeadEdit_Deletion.dart';
import 'package:baba_tracker/view/editionanddeletion/babyHeightEdit_deletion.dart';
import 'package:baba_tracker/view/editionanddeletion/babyWeight_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyHeightDataTable extends StatelessWidget {
  final List<HeightMeasureData> heightmeasuredata;
  const BabyHeightDataTable({super.key, required this.heightmeasuredata});

  @override
  Widget build(BuildContext context) {
    if (heightmeasuredata.isEmpty) {
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
      rows: heightmeasuredata.map((records) {
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
                    builder: (context) => BabyHeightEdit(
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
