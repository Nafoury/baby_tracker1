import 'dart:ffi';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/models/solidsData.dart';
import 'package:baba_tracker/provider/nursingDataProvider.dart';
import 'package:baba_tracker/provider/solids_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NursingEditAndDeletion extends StatefulWidget {
  final NusringData entryData;

  NursingEditAndDeletion({
    required this.entryData,
  });

  @override
  _NursingEditAndDeletionState createState() => _NursingEditAndDeletionState();
}

class _NursingEditAndDeletionState extends State<NursingEditAndDeletion> {
  Crud crud = Crud();
  late DateTime? startDate;
  late NursingDataProvider nursingDataProvider;
  late SolidsProvider solidsProvider;
  late String leftduration;
  late String rightduration;
  late String brestside;
  late String side;
  String? selectedValue;
  String? dropdownError;
  late Duration? total;
  late Function(String)? onSideChanged;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    brestside = widget.entryData.startingBreast.toString();
    leftduration = widget.entryData.leftDuration.toString();
    rightduration = widget.entryData.rightDuration.toString();
    side = widget.entryData.nursingSide.toString();
  }

  @override
  void didChangeDependencies() {
    nursingDataProvider =
        Provider.of<NursingDataProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  String _parseRightDuration(String rightDurationStr) {
    Duration rightDuration = Duration(); // Initialize to zero

    // Parse leftDurationStr and rightDurationStr into Duration objects
    if (rightDurationStr.isNotEmpty) {
      rightDuration = Duration(
        hours: int.parse(rightDurationStr.split(':')[0]),
        minutes: int.parse(rightDurationStr.split(':')[1]),
        seconds: int.parse(rightDurationStr.split(':')[2]),
      );
    }

    // Add the durations together
    Duration totalNursingAmounts = rightDuration;

    // Initialize variables to hold different parts of the duration
    String hoursPart = '';
    String minutesPart = '';
    String secondsPart = '';

    // Check if total duration is less than a minute
    if (totalNursingAmounts.inSeconds < 60) {
      secondsPart = '${totalNursingAmounts.inSeconds}s';
    } else {
      // Check if hours, minutes, or seconds are greater than zero
      if (totalNursingAmounts.inHours > 0) {
        hoursPart = '${totalNursingAmounts.inHours}h';
      }
      if (totalNursingAmounts.inMinutes % 60 > 0) {
        minutesPart = '${totalNursingAmounts.inMinutes % 60}m';
      }
      if (totalNursingAmounts.inSeconds % 60 > 0) {
        secondsPart = '${totalNursingAmounts.inSeconds % 60}s';
      }
    }

    // Concatenate the parts together
    String formattedDuration = '$hoursPart$minutesPart$secondsPart';

    return formattedDuration;
  }

  String _parseLeftDuration(String leftDurationStr) {
    Duration leftDuration = Duration(); // Initialize to zero

    // Parse leftDurationStr and rightDurationStr into Duration objects
    if (leftDurationStr.isNotEmpty) {
      leftDuration = Duration(
        hours: int.parse(leftDurationStr.split(':')[0]),
        minutes: int.parse(leftDurationStr.split(':')[1]),
        seconds: int.parse(leftDurationStr.split(':')[2]),
      );
    }

    // Add the durations together
    Duration totalNursingAmounts = leftDuration;

    // Initialize variables to hold different parts of the duration
    String hoursPart = '';
    String minutesPart = '';
    String secondsPart = '';

    // Check if total duration is less than a minute
    if (totalNursingAmounts.inSeconds < 60) {
      secondsPart = '${totalNursingAmounts.inSeconds}s';
    } else {
      // Check if hours, minutes, or seconds are greater than zero
      if (totalNursingAmounts.inHours > 0) {
        hoursPart = '${totalNursingAmounts.inHours}h';
      }
      if (totalNursingAmounts.inMinutes % 60 > 0) {
        minutesPart = '${totalNursingAmounts.inMinutes % 60}m';
      }
      if (totalNursingAmounts.inSeconds % 60 > 0) {
        secondsPart = '${totalNursingAmounts.inSeconds % 60}s';
      }
    }

    // Concatenate the parts together
    String formattedDuration = '$hoursPart$minutesPart$secondsPart';

    return formattedDuration;
  }

  String _parseDuration(String leftDurationStr, String rightDurationStr) {
    Duration leftDuration = Duration(); // Initialize to zero
    Duration rightDuration = Duration(); // Initialize to zero

    // Parse leftDurationStr and rightDurationStr into Duration objects
    if (leftDurationStr.isNotEmpty) {
      leftDuration = Duration(
        hours: int.parse(leftDurationStr.split(':')[0]),
        minutes: int.parse(leftDurationStr.split(':')[1]),
        seconds: int.parse(leftDurationStr.split(':')[2]),
      );
    }
    if (rightDurationStr.isNotEmpty) {
      rightDuration = Duration(
        hours: int.parse(rightDurationStr.split(':')[0]),
        minutes: int.parse(rightDurationStr.split(':')[1]),
        seconds: int.parse(rightDurationStr.split(':')[2]),
      );
    }

    // Add the durations together
    Duration totalNursingAmounts = leftDuration + rightDuration;

    // Initialize variables to hold different parts of the duration
    String hoursPart = '';
    String minutesPart = '';
    String secondsPart = '';

    // Check if total duration is less than a minute
    if (totalNursingAmounts.inSeconds < 60) {
      secondsPart = '${totalNursingAmounts.inSeconds}s';
    } else {
      // Check if hours, minutes, or seconds are greater than zero
      if (totalNursingAmounts.inHours > 0) {
        hoursPart = '${totalNursingAmounts.inHours}h';
      }
      if (totalNursingAmounts.inMinutes % 60 > 0) {
        minutesPart = '${totalNursingAmounts.inMinutes % 60}m';
      }
      if (totalNursingAmounts.inSeconds % 60 > 0) {
        secondsPart = '${totalNursingAmounts.inSeconds % 60}s';
      }
    }

    // Concatenate the parts together
    String formattedDuration = '$hoursPart$minutesPart$secondsPart';

    return formattedDuration;
  }

  Future<bool> _checkDuplicateNursingData(DateTime startDate) async {
    List<NusringData> existingData =
        await nursingDataProvider.getNursingRecords();
    bool duplicateExists = existingData.any((nursing) =>
        nursing.startingBreast == brestside &&
        nursing.leftDuration == leftduration &&
        nursing.rightDuration == rightduration &&
        nursing.date!.year == startDate.year &&
        nursing.date!.month == startDate.month &&
        nursing.date!.day == startDate.day &&
        nursing.date!.hour == startDate.hour &&
        nursing.date!.minute == startDate.minute);
    return duplicateExists;
  }

  Future<bool> _checkDuplicateNursingData1(DateTime startDate,
      String? leftDurationStr, String? rightDurationStr) async {
    List<NusringData> existingData =
        await nursingDataProvider.getNursingRecords();

    // Calculate end date based on start date and duration
    Duration totalDuration = _parseDuration1(leftDurationStr, rightDurationStr);

    bool duplicateExists = existingData.any((nursingRecord) {
      // Calculate total duration of left and right feeding for the existing record
      Duration recordDuration = _parseDuration1(
          nursingRecord.leftDuration, nursingRecord.rightDuration);

      // Check if the start date matches and if the total duration matches the recorded duration
      return nursingRecord.date == startDate && recordDuration == totalDuration;
    });

    return duplicateExists;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(children: [
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
                "Edit Nursing",
                style: TextStyle(
                  color: Tcolor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (widget.entryData.feedId != null) {
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
                                nursingDataProvider.deleteNursingRecord(
                                    widget.entryData.feedId!);
                                ScaffoldMessenger.of(context).showSnackBar(
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
              ),
            ],
          ),
          Divider(
            height: 3,
          ),
          SizedBox(
            height: 15,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Change the duration\n of breast below",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showHourPicker(context, leftduration);
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purpleAccent.shade100.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          "L",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Text(_parseLeftDuration(leftduration))
                ]),
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showHourPicker1(context, rightduration);
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purpleAccent.shade100.withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          'R',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(_parseRightDuration(rightduration))
                ])
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 350,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.purpleAccent.shade100.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(7)),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Duration',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Text(_parseDuration(leftduration, rightduration))
                        ],
                      ),
                      Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 80, // Adjust maximum width of the box
                              maxHeight: 35, // Adjust maximum height of the box
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: ["R", "L"]
                                    .map((name) => DropdownMenuItem(
                                          value: name,
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                              color: Tcolor.gray,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                    dropdownError = null;
                                    brestside = value ?? '';
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                hint: const Text(
                                  'First Bresat',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${brestside ?? ''}',
                            style: TextStyle(
                              fontSize: 14.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
                onTap: () {
                  _showStartDatePicker(context, startDate!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date & Time ",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 13,
                        )),
                    Text(
                      DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
            Divider()
          ]),
          SizedBox(height: 20),
          RoundButton(
              onpressed: () async {
                if (leftduration.isEmpty || rightduration.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Image.asset(
                          "assets/images/warning.png",
                          height: 60,
                          width: 60,
                        ),
                        content: Text("the duration can't be zero"),
                        actions: [
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
                bool existingData = await _checkDuplicateNursingData1(
                    startDate!, leftduration, rightduration);
                if (existingData) {
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
                            "Nursing data of the same date,and hour already exists."),
                        actions: [
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
                  nursingDataProvider.editNursingRecord(NusringData(
                    date: startDate,
                    leftDuration: leftduration,
                    rightDuration: rightduration,
                    startingBreast: brestside,
                    nursingSide: side,
                    feedId: widget.entryData.feedId!,
                  ));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Image.asset(
                          "assets/images/change.png",
                          height: 60,
                          width: 60,
                        ),
                        content: Text("Nursing Data was successfully updated."),
                        actions: [
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
              },
              title: "Save changes"),
        ])),
      ),
    );
  }

  void _showStartDatePicker(BuildContext context, DateTime initialDateTime) {
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDateTime,
            minimumDate: minimumDateTime,
            maximumDate: maximumDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                startDate = newDateTime;
              });
            },
          ),
        );
      },
    );
  }

  void _showHourPicker(BuildContext context, String initialDuration) {
    Duration initialDurationParsed = _parseDurationString(initialDuration);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: DateTime(2000, 1, 1, initialDurationParsed.inHours,
                initialDurationParsed.inMinutes),
            onDateTimeChanged: (DateTime newDateTime) {
              Duration newDuration = Duration(
                  hours: newDateTime.hour, minutes: newDateTime.minute);
              setState(() {
                leftduration = _formatDurationString(newDuration);
              });
            },
          ),
        );
      },
    );
  }

  void _showHourPicker1(BuildContext context, String initialDuration) {
    Duration initialDurationParsed = _parseDurationString(initialDuration);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: DateTime(2000, 1, 1, initialDurationParsed.inHours,
                initialDurationParsed.inMinutes),
            onDateTimeChanged: (DateTime newDateTime) {
              Duration newDuration = Duration(
                  hours: newDateTime.hour, minutes: newDateTime.minute);
              setState(() {
                rightduration = _formatDurationString(newDuration);
              });
            },
          ),
        );
      },
    );
  }

  Duration _parseDurationString(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration _parseDuration1(String? leftDurationStr, String? rightDurationStr) {
    // Initialize left and right durations to zero
    Duration leftDuration = Duration();
    Duration rightDuration = Duration();

    // Parse leftDurationStr and rightDurationStr into Duration objects
    if (leftDurationStr != null && leftDurationStr.isNotEmpty) {
      leftDuration = Duration(
        hours: int.parse(leftDurationStr.split(':')[0]),
        minutes: int.parse(leftDurationStr.split(':')[1]),
        seconds: int.parse(leftDurationStr.split(':')[2]),
      );
    }
    if (rightDurationStr != null && rightDurationStr.isNotEmpty) {
      rightDuration = Duration(
        hours: int.parse(rightDurationStr.split(':')[0]),
        minutes: int.parse(rightDurationStr.split(':')[1]),
        seconds: int.parse(rightDurationStr.split(':')[2]),
      );
    }

    // Calculate the total duration by adding left and right durations
    Duration totalDuration = leftDuration + rightDuration;

    return totalDuration;
  }
}
