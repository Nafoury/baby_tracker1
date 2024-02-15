import 'package:baby_tracker/controller/diapercontroller.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:get/get.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/controller/diapercontroller.dart';
import 'package:provider/provider.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:intl/intl.dart';
import 'package:baby_tracker/common_widgets/notebutton.dart';
import 'package:baby_tracker/view/editionanddeletion/diaper_edit.dart';

class DiaperChange extends StatefulWidget {
  const DiaperChange({super.key});

  @override
  State<DiaperChange> createState() => _DiaperChangeState();
}

class _DiaperChangeState extends State<DiaperChange> {
  int selectedbutton = 0;
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  String status = '';
  final _note = TextEditingController();

  DiaperController diaperController = DiaperController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed("/mainTab");
                    },
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(width: 85),
                  Text(
                    "Diaper",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 0.05,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Tcolor.lightgray,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: (media.width * 0.9),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            alignment: selectedbutton == 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: (media.width * 0.5) - 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient:
                                    LinearGradient(colors: Tcolor.primaryG),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedbutton = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "Diaper",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: selectedbutton == 0
                                                ? Tcolor.white
                                                : Tcolor.gray,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedbutton = 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "Summary",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: selectedbutton == 1
                                                ? Tcolor.white
                                                : Tcolor.gray,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedbutton == 0)
                    Column(
                      children: [
                        TrackingWidget(
                          trackingType: TrackingType.Diaper,
                          controller: _note,
                          startDate: startDate,
                          status: status,
                          onStatusChanged: (String newStatus) {
                            setState(() {
                              status = newStatus;
                            });
                          },
                          onDateStratTimeChanged: (DateTime newStartDate) {
                            setState(() {
                              startDate = newStartDate;
                            });
                          },
                          onNoteChanged: (String note) {
                            _note.text = note;
                          },
                        ),
                        SizedBox(height: 300),
                        RoundButton(
                          onpressed: () async {
                            var diaperDataprovider =
                                Provider.of<DiaperProvider>(context,
                                    listen: false);
                            if (status.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Status is empty'),
                                    content: Text("Status is required"),
                                  );
                                },
                              );
                              return;
                            }

                            // Check if a record with the same date and status exists
                            bool recordExists = diaperDataprovider.diaperRecords
                                .any((diaperData) =>
                                    diaperData.startDate == startDate &&
                                    diaperData.status == status);

                            if (recordExists) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Exisiting record '),
                                    content: Text(
                                        "Record with the same date and status already exists"),
                                  );
                                },
                              );
                              return;
                            }

                            DiaperData diaperData = DiaperData(
                                startDate: startDate,
                                status: status,
                                note: _note.text,
                                infoid: sharedPref.getString("info_id") ?? "");
                            await diaperController.saveDiaperData(
                                diaperData: diaperData);

                            // Show a success message or handle as needed
                            diaperDataprovider.addDiaperRecord(diaperData);
                            setState(() {
                              startDate = DateTime
                                  .now(); // Replace with your initial/default date values
                              _note.clear();
                              status =
                                  ''; // Replace with your initial/default date values
                            });
                          },
                          title: "Save change",
                        ),
                      ],
                    ),
                  if (selectedbutton == 1)
                    Consumer<DiaperProvider>(
                      builder: (context, diaperDataprovider, _) {
                        List<DiaperData> diaperRecords =
                            diaperDataprovider.diaperRecords;
                        return DataTable(
                          columns: [
                            DataColumn(
                              label: Text('Date&time'),
                              numeric: false,
                            ),
                            DataColumn(label: Text('Note')),
                            DataColumn(
                              label: Text('Type'),
                            ),
                          ],
                          rows: diaperRecords.map((diaperData) {
                            String note = diaperData.note;
                            String type = diaperData.status;
                            String formattedDate =
                                DateFormat('dd MMM yyyy HH:mm ')
                                    .format(diaperData.startDate);

                            return DataRow(cells: [
                              DataCell(Text(formattedDate)),
                              DataCell(
                                note.isNotEmpty
                                    ? EntryButton(
                                        entryData: diaperData,
                                        onTap: () {},
                                      )
                                    : Container(), // Show the button only if note is not empty
                              ),
                              DataCell(Text(type))
                            ]);
                          }).toList(),
                        );
                      },
                    ),

                  //sleeping UI
                ],
              )
            ]))),
      ),
    );
  }
}
