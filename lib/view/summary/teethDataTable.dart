import 'package:baby_tracker/common_widgets/roundCircle.dart';
import 'package:baby_tracker/controller/teethController.dart';
import 'package:baby_tracker/models/teethModel.dart';
import 'package:baby_tracker/view/editionanddeletion/teethEdit_deletion.dart';
import 'package:baby_tracker/view/editionanddeletion/vaccine_edition_deletion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeethRecordsTable extends StatefulWidget {
  const TeethRecordsTable({Key? key}) : super(key: key);

  @override
  State<TeethRecordsTable> createState() => _TeethRecordsTableState();
}

class _TeethRecordsTableState extends State<TeethRecordsTable> {
  final TeethController teethController = TeethController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TeethData>>(
      future: teethController.retrieveTeethData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<TeethData> teethDatalist = snapshot.data ?? [];
          return DataTable(
            columnSpacing: 10,
            columns: [
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Upper',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Lower',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(''),
              ),
            ],
            rows: teethDatalist.map((records) {
              return DataRow(cells: [
                DataCell(
                  Text(
                    DateFormat('dd MMM yy').format(records.date!),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DataCell(Text(
                  records.upper.toString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                )),
                DataCell(Text(
                  records.lower.toString(),
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
                            builder: (context) =>
                                TeethEdit(entryData: records)),
                      );
                    },
                    icon: Image.asset(
                      "assets/images/arroNext.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ]);
            }).toList(),
          );
        }
      },
    );
  }
}
