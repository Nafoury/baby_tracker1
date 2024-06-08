import 'dart:ffi';
import 'package:baba_tracker/common_widgets/addingactivites.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/provider/sleep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:provider/provider.dart';

import '../../provider/diaper_provider.dart';

class SleepEdit extends StatefulWidget {
  final SleepData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  const SleepEdit({
    super.key,
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _SleepEditState createState() => _SleepEditState();
}

class _SleepEditState extends State<SleepEdit> {
  late SleepProvider sleepProvider;
  Crud crud = Crud();
  late DateTime startDate;
  late DateTime endDate;
  late String status;
  late String note;
  late TextEditingController noteController;

  Future<bool> _checkDuplicateSleepData(
      DateTime startDate, DateTime endDate) async {
    List<SleepData> existingData = await sleepProvider.getSleepRecords();
    bool duplicateExists = existingData.any((sleepRecord) =>
        (startDate.isBefore(sleepRecord.endDate!) ||
            startDate.isAtSameMomentAs(sleepRecord.endDate!)) &&
        (endDate.isAfter(sleepRecord.startDate!) ||
            endDate.isAtSameMomentAs(sleepRecord.startDate!)));
    return duplicateExists;
  }

  Future<bool> _checkDuplicateStartSleepData(DateTime startDate) async {
    List<SleepData> existingData = await sleepProvider.getSleepRecords();
    bool duplicateExists = existingData.any(
        (sleepRecord) => startDate.isAtSameMomentAs(sleepRecord.startDate!));
    return duplicateExists;
  }

  Future<bool> _checkDuplicateEndSleepData(DateTime endDate) async {
    List<SleepData> existingData = await sleepProvider.getSleepRecords();
    bool duplicateExists = existingData
        .any((sleepRecord) => endDate.isAtSameMomentAs(sleepRecord.endDate!));
    return duplicateExists;
  }

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate ?? DateTime.now();
    endDate = widget.entryData.endDate ?? DateTime.now();
    note = widget.entryData.note.toString();

    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(
                      "Edit Sleep",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.sleepId != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                    "Are you sure you want to delete this record?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      sleepProvider.deleteSleepRecord(
                                          widget.entryData.sleepId!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Durations.medium1,
                                          backgroundColor:
                                              Tcolor.gray.withOpacity(0.4),
                                          content: Text(
                                              "Record was successfully deleted."),
                                        ),
                                      );
                                      Navigator.of(context).pop();

                                      // Go back to the previous page
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red.shade200),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TrackingWidget(
                  trackingType: TrackingType.Sleeping,
                  startDate: startDate,
                  endDate: endDate,
                  controller: noteController,
                  onDateTimeChanged:
                      (DateTime newStartDate, DateTime newEndDate) {
                    setState(() {
                      startDate = newStartDate;
                      endDate = newEndDate;
                    });
                  },
                  onNoteChanged: (String note) {
                    noteController;
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () async {
                      if (widget.entryData.sleepId != null) {
                        Duration duration = endDate.difference(startDate);
                        if (duration.inMinutes <= 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  "Duration can't be zero or less",
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        bool existingData =
                            await _checkDuplicateSleepData(startDate, endDate);
                        if (existingData) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  'Sleep data of start date or end date already exists.',
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        bool existingStartDate =
                            await _checkDuplicateStartSleepData(startDate);

                        if (existingStartDate) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  'Sleep data of start date already exists.',
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        bool existingEndDate =
                            await _checkDuplicateEndSleepData(startDate);
                        if (existingEndDate) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/warning.png",
                                  height: 60,
                                  width: 60,
                                ),
                                content: Text(
                                  'Sleep data of end date already exists.',
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        } else {
                          sleepProvider.editSleepRecord(SleepData(
                              startDate: startDate,
                              endDate: endDate,
                              note: note,
                              sleepId: widget.entryData.sleepId!));

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/check.png",
                                  height: 60,
                                  width: 60,
                                ),
                                content: Text(
                                  'Sleep Data was successfully added',
                                  style: TextStyle(fontStyle: FontStyle.normal),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    title: "Save changes")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
