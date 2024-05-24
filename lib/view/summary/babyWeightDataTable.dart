import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/view/editionanddeletion/babyWeight_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyWeightDataTable extends StatelessWidget {
  final List<WeightData> weightRecords;
  const BabyWeightDataTable({super.key, required this.weightRecords});

  @override
  Widget build(BuildContext context) {
    if (weightRecords.isEmpty) {
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
              'Weight',
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
      rows: weightRecords.map((records) {
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
            '${records.weight.toString()} Kg',
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
                    builder: (context) => BabyWeightEdit(
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
