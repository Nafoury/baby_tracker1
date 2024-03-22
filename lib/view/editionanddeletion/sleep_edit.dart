import 'dart:ffi';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Get.offAllNamed("/mainTab");
                      },
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(width: 85),
                    Text(
                      "Sleep",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 80),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.sleepId != null) {
                          sleepProvider
                              .deleteSleepRecord(widget.entryData.sleepId!);
                        }
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Column(
                      children: [
                        SizedBox(height: 25),
                        Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    );
                  },
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return GestureDetector(
                            onTap: () {
                              _showDatePicker(context,
                                  true); // Show date picker for start date
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Start Date & Time ",
                                    style: TextStyle(
                                      color: Tcolor.black,
                                      fontSize: 13,
                                    )),
                                Text(
                                  DateFormat('dd MMM yyyy  HH:mm')
                                      .format(startDate!),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ));

                      case 1:
                        return GestureDetector(
                          onTap: () {
                            _showDatePicker(context,
                                false); // Show date picker for start date
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("End Date & Time ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 13,
                                  )),
                              Text(
                                DateFormat('dd MMM yyyy  HH:mm')
                                    .format(endDate!),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      case 2:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Duration "),
                            Text(_formattedDuration(
                                endDate!.difference(startDate!))),
                          ],
                        );
                      case 3:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: TextField(
                              controller: noteController,
                              onChanged: (newNote) {
                                setState(() {
                                  note = newNote;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "note",
                                // Set your desired hint text
                              ),
                            ))
                          ],
                        );

                      default:
                        return SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.sleepId != null) {
                        sleepProvider.editSleepRecord(SleepData(
                            startDate: startDate,
                            endDate: endDate,
                            note: note,
                            sleepId: widget.entryData.sleepId!));
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

  void _showDatePicker(BuildContext context, bool isStartDate) {
    DateTime? newStartDate = startDate;
    DateTime? newEndDate = endDate;
    DateTime? initialDateTime = isStartDate ? startDate : endDate;
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40)); // Previous date
    DateTime maximumDateTime = DateTime.now(); // Current date

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 200,
              color: Colors.white,
              child: Stack(
                children: [
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initialDateTime ?? DateTime.now(),
                    minimumDate: minimumDateTime,
                    maximumDate: maximumDateTime,
                    onDateTimeChanged: (DateTime? newDateTime) {
                      setState(() {
                        if (newDateTime != null) {
                          if (isStartDate) {
                            newStartDate = newDateTime;
                          } else {
                            newEndDate = newDateTime;
                          }
                        }
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Done'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }
}
