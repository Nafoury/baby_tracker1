import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/view/editionanddeletion/momweightData_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightDataTable extends StatelessWidget {
  final List<MomData> weightRecords;
  const WeightDataTable({super.key, required this.weightRecords});

  @override
  Widget build(BuildContext context) {
    if (weightRecords == null || weightRecords!.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/weigh_scale.png',
                height: 90,
                width: 90,
              ),
              Text("There's no mum's weight data available")
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
      rows: weightRecords.map((record) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(record.date!),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),

          DataCell(Text(
            '${record.weight.toString()} Kg',
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
                    builder: (context) => MomWeightEdit(
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
}
