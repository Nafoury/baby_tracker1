import 'package:baby_tracker/common_widgets/roundCircle.dart';

import 'package:baby_tracker/models/tempData.dart';
import 'package:baby_tracker/view/editionanddeletion/sleep_edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TempDataTable extends StatelessWidget {
  final List<TempData> tempRecords;
  const TempDataTable({super.key, required this.tempRecords});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 22,
      columns: [
        DataColumn(
          label: Text(
            'Date',
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
      rows: tempRecords.map((record) {
        return DataRow(cells: [
          DataCell(
            Text(
              DateFormat('dd MMM yy').format(record.date!),
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          DataCell(Text(
            convertCelsiusToFahrenheit(record.temp!).toStringAsFixed(1),
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600,
                fontSize: 13),
          )),
          DataCell(
            record.note.toString().isNotEmpty
                ? RoundCircle()
                : Text(
                    record.note.toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                  ),
          ),

          DataCell(
            IconButton(
              onPressed: () {},
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
