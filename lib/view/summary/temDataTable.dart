import 'package:baba_tracker/common_widgets/roundCircle.dart';

import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/view/editionanddeletion/sleep_edit.dart';
import 'package:baba_tracker/view/editionanddeletion/temp_edit_delete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TempDataTable extends StatelessWidget {
  final List<TempData> tempRecords;
  const TempDataTable({super.key, required this.tempRecords});

  @override
  Widget build(BuildContext context) {
    if (tempRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 90),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/temperature.png',
                height: 90,
                width: 90,
              ),
              Text("There's no Temprature data available")
            ],
          ),
        ),
      );
    }
    return DataTable(
      columnSpacing: 7,
      columns: [
        DataColumn(
          label: Text(
            'Date & Time',
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
            'Temperature',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontSize: 3),
          ),
        ),
      ],
      rows: tempRecords.map((record) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy hh:mm').format(record.date!),
              style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
          DataCell(
            record.note.toString().isNotEmpty
                ? RoundCircle()
                : Text(
                    record.note.toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.w600,
                        fontSize: 10),
                  ),
          ),

          DataCell(Text(
            '${convertCelsiusToFahrenheit(record.temp!).toStringAsFixed(1)} C',
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
                      builder: (context) => TempEdit(entryData: record)),
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

  double convertCelsiusToFahrenheit(double celsius) {
    return (celsius * 5) + 37.0;
  }
}
