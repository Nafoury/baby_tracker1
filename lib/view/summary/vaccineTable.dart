import 'package:baby_tracker/common_widgets/roundCircle.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:baby_tracker/provider/vaccine_provider.dart';
import 'package:baby_tracker/view/editionanddeletion/vaccine_edition_deletion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VaccineRecordsTable extends StatefulWidget {
  const VaccineRecordsTable({Key? key}) : super(key: key);

  @override
  State<VaccineRecordsTable> createState() => _VaccineRecordsTableState();
}

class _VaccineRecordsTableState extends State<VaccineRecordsTable> {
  late List<VaccineData> vaccineRecords = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vaccineProvider =
        Provider.of<VaccineProvider>(context, listen: false);
    fetchVaccineRecords(vaccineProvider);
  }

  Future<void> fetchVaccineRecords(VaccineProvider vaccineProvider) async {
    try {
      List<VaccineData> records = await vaccineProvider.getVaccineRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        vaccineRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    if (vaccineRecords.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 90),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/injection.png',
                height: 90,
                width: 90,
              ),
              Text("There's no vaccine data available")
            ],
          ),
        ),
      );
    }
    return Consumer<VaccineProvider>(
      builder: (context, vaccineProvider, child) {
        return DataTable(
          columnSpacing: 30,
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
          rows: vaccineRecords.map((records) {
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
                '${records.type.toString().substring(0, records.type.toString().indexOf('(')).trim()}', // Displaying only the first 10 characters
                style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              )),
              DataCell(
                records.note.toString().isNotEmpty
                    ? RoundCircle()
                    : Text(
                        records.note.toString(),
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
                        builder: (context) => VaccineEdit(
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
              ),
            ]);
          }).toList(),
        );
      },
    );
  }
}
