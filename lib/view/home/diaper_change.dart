import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
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
import 'package:baby_tracker/localDatabase/sqlite_diaperchange.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';

class DiaperChange extends StatefulWidget {
  const DiaperChange({Key? key});

  @override
  State<DiaperChange> createState() => _DiaperChangeState();
}

class _DiaperChangeState extends State<DiaperChange> {
  int selectedButton = 0;
  DateTime startDate = DateTime.now();
  String status = '';
  final _note = TextEditingController();
  List<DiaperData> diaperRecords = [];
  DiaperController diaperController = DiaperController();
  Crud crud = Crud();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 0.05),
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
                              alignment: selectedButton == 0
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
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedButton = 0;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          "Diaper",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: selectedButton == 0
                                                ? Tcolor.white
                                                : Tcolor.gray,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedButton = 1;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          "Summary",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: selectedButton == 1
                                                ? Tcolor.white
                                                : Tcolor.gray,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
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
                    const SizedBox(height: 20),
                    if (selectedButton == 0)
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

                              bool recordExists = diaperRecords.any(
                                (diaperData) =>
                                    diaperData.startDate == startDate &&
                                    diaperData.status == status,
                              );

                              if (recordExists) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Existing record'),
                                      content: Text(
                                        "Record with the same date and status already exists",
                                      ),
                                    );
                                  },
                                );
                                return;
                              }

                              DiaperData diaperData = DiaperData(
                                startDate: startDate,
                                status: status,
                                note: _note.text,
                                infoid: sharedPref.getString("info_id") ?? "",
                              );

                              await diaperController.saveDiaperData(
                                diaperData: diaperData,
                              );

                              setState(() {
                                startDate = DateTime.now();
                                _note.clear();
                                status = '';
                              });
                            },
                            title: "Save change",
                          ),
                        ],
                      ),
                    if (selectedButton == 1)
                      FutureBuilder(
                        future: diaperController.retrieveDiaperData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Text("Loading.."));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            diaperRecords =
                                (snapshot.data as List).cast<DiaperData>();

                            return DataTable(
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'Date',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Note',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Type',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                              rows: diaperRecords.map((diaperData) {
                                String note = diaperData.note;
                                String type = diaperData.status;
                                String formattedDate = DateFormat('dd MMM yy ')
                                    .format(diaperData.startDate);

                                return DataRow(cells: [
                                  DataCell(Text(
                                    formattedDate,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontWeight: FontWeight.w600),
                                  )),
                                  DataCell(
                                    note.isNotEmpty
                                        ? EntryButton(
                                            entryData: diaperData,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Diaperchange(
                                                    entryData: diaperData,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(),
                                  ),
                                  DataCell(Text(
                                    type,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontWeight: FontWeight.w600),
                                  ))
                                ]);
                              }).toList(),
                            );
                          } else {
                            return Text('No data available.');
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
