import 'package:baby_tracker/common_widgets/roundCircle.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:baby_tracker/provider/medications_provider.dart';
import 'package:baby_tracker/view/editionanddeletion/med_edition_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MediciationRecordsTable extends StatefulWidget {
  const MediciationRecordsTable({Key? key}) : super(key: key);

  @override
  State<MediciationRecordsTable> createState() =>
      _MediciationRecordsTableState();
}

class _MediciationRecordsTableState extends State<MediciationRecordsTable> {
  late List<MedData> medicationRecords = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final medicationsProvider =
        Provider.of<MedicationsProvider>(context, listen: false);
    fetchMedicationRecords(medicationsProvider);
  }

  Future<void> fetchMedicationRecords(
      MedicationsProvider medicationsProvider) async {
    try {
      List<MedData> records = await medicationsProvider.getMedicationRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        medicationRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    if (medicationRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 90),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/meds.png',
                height: 90,
                width: 90,
              ),
              Text("There's no medications data available")
            ],
          ),
        ),
      );
    }
    return Consumer<MedicationsProvider>(
      builder: (context, medicationsProvider, child) {
        return DataTable(
          columnSpacing: 24,
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
                'Type',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Note',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                '',
              ),
            ),
          ],
          rows: medicationRecords.map((record) {
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
                record.type.toString(),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediciationEdit(
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
      },
    );
  }
}
