import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/view/editionanddeletion/babyWeight_edit_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyWeightDataTable extends StatelessWidget {
  final List<WeightData> weightRecords;
  final double birthWeight; // Added birthWeight as a parameter

  const BabyWeightDataTable({
    super.key,
    required this.weightRecords,
    required this.birthWeight, // Initialize birthWeight
  });

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

    // Calculate weight changes
    List<String> weightChanges = calculateWeightChanges();

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
            'Weight',
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
        weightRecords.length,
        (index) => DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(weightRecords[index].date!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          DataCell(Text(
            '${weightRecords[index].weight.toString()} Kg',
            style: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          )),
          DataCell(Text(
            weightChanges[index],
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
                    builder: (context) => BabyWeightEdit(
                      entryData: weightRecords[index],
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

    if (weightRecords.isNotEmpty) {
      double previousWeight = birthWeight;

      for (int i = 0; i < weightRecords.length; i++) {
        double currentWeight = weightRecords[i].weight!;
        double change = currentWeight - previousWeight;
        String changeString =
            (change >= 0 ? '+' : '') + change.toStringAsFixed(2) + ' Kg';
        changes.add(changeString);
        previousWeight = currentWeight;
      }
    }

    return changes;
  }
}
