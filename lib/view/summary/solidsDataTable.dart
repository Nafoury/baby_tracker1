import 'package:baby_tracker/common_widgets/roundCircle.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:baby_tracker/provider/solids_provider.dart';
import 'package:baby_tracker/view/editionanddeletion/solids_editon_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SolidsDataTable extends StatelessWidget {
  final List<SolidsData> solidsRecords;
  const SolidsDataTable({super.key, required this.solidsRecords});

  @override
  Widget build(BuildContext context) {
    return Consumer<SolidsProvider>(
      builder: (context, solidsProvider, child) {
        List<SolidsData> solidsRecords = solidsProvider.solidsRecords;
        if (solidsRecords == null || solidsRecords!.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 150),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/baby_food.png',
                    height: 90,
                    width: 90,
                  ),
                  Text("There's no solids data available")
                ],
              ),
            ),
          );
        }
        return DataTable(
          columnSpacing: 10,
          columns: [
            DataColumn(
              label: Text(
                'Date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
                label: Text(
                  'Amount',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                numeric: true),
            DataColumn(
              label: Text(
                'Note',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(''),
            ),
          ],
          rows: solidsRecords.map((solidsRecords) {
            return DataRow(cells: [
              DataCell(
                Text(
                  DateFormat('dd MMM yy hh:mm').format(solidsRecords.date!),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${(solidsRecords.dairy!) + (solidsRecords.fruits!) + (solidsRecords.grains!) + (solidsRecords.protein!) + (solidsRecords.veg!)} g',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              DataCell(
                solidsRecords.note.toString().isNotEmpty
                    ? RoundCircle()
                    : Text(
                        solidsRecords.note.toString(),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              DataCell(
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SolidsEdit(entryData: solidsRecords)),
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
      },
    );
  }
}
