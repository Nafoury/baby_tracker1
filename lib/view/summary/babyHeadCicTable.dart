import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/view/editionanddeletion/babyHeadEdit_Deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyHeadDataTable extends StatelessWidget {
  final List<MeasureData> measureRecords;
  final double birthHead;
  const BabyHeadDataTable(
      {super.key, required this.measureRecords, required this.birthHead});

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
    List<String> headChanges = calculateWeightChanges();

    return DataTable(
      columnSpacing: 45,
      columns: [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Head',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Change',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontSize: 3),
          ),
        ),
      ],
      rows: List<DataRow>.generate(
        measureRecords.length,
        (index) => DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(measureRecords[index].date!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          DataCell(Text(
            '${measureRecords[index].measure.toString()} cm',
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          )),
          DataCell(Text(
            headChanges[index],
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          )),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BabyHeadEdit(
                      entryData: measureRecords[index],
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
        ]),
      ),
    );
  }

  List<String> calculateWeightChanges() {
    List<String> changes = [];

    if (measureRecords.isNotEmpty) {
      double previousWeight = birthHead;

      for (int i = 0; i < measureRecords.length; i++) {
        double currentWeight = measureRecords[i].measure!;
        double change = currentWeight - previousWeight;
        String changeString =
            (change >= 0 ? '+' : '') + change.toStringAsFixed(2) + ' cm';
        changes.add(changeString);
        previousWeight = currentWeight;
      }
    }

    return changes;
  }
}
