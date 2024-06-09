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
  final double babyheight;
  const BabyHeightDataTable(
      {super.key, required this.heightmeasuredata, required this.babyheight});

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
    List<String> heightChanges = calculateWeightChanges();

    return DataTable(
      columnSpacing: 42,
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
            'Measure',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            'Change',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          numeric: false,
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontSize: 3),
          ),
        ),
      ],
      rows: List<DataRow>.generate(
        heightmeasuredata.length,
        (index) => DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(heightmeasuredata[index].date!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          DataCell(Text(
            '${heightmeasuredata[index].measure.toString()} cm',
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          )),
          DataCell(Text(
            heightChanges[index],
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
                    builder: (context) => BabyHeightEdit(
                      entryData: heightmeasuredata[index],
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

    if (heightmeasuredata.isNotEmpty) {
      double previousWeight = babyheight;

      for (int i = 0; i < heightmeasuredata.length; i++) {
        double currentWeight = heightmeasuredata[i].measure!;
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
