import 'dart:ffi';
import 'package:baba_tracker/Services/notifi_service.dart';
import 'package:baba_tracker/Services/workManager.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MediciationEdit extends StatefulWidget {
  final MedData entryData;
  final Function(DateTime)? onDateStratTimeChanged;

  MediciationEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _MediciationEditState createState() => _MediciationEditState();
}

class _MediciationEditState extends State<MediciationEdit> {
  Crud crud = Crud();
  late DateTime startDate;
  late String type;
  late String note;
  late TextEditingController noteController;
  late MedicationsProvider medicationsProvider;
  bool isSwitch = false;

  final List<String> reminderIntervals = [
    '15 mins',
    '1 hour',
    '1 hour 30 min',
    '2 hours',
    '2 hour 30 min',
    '3 hours',
    '3 hour 30 min',
    '4 hours',
    '6 hours',
  ];

  String selectedInterval = '1 hour';

  void _handleSwitchChange(bool value) {
    setState(() {
      isSwitch = value;
    });
  }

  void _scheduleNotification() async {
    if (isSwitch) {
      int hours = 0;
      int minutes = 0;
      if (selectedInterval.contains('hour')) {
        hours = int.parse(selectedInterval.split(' ')[0]);
        if (selectedInterval.contains('30 min')) {
          minutes = 30;
        }
      } else if (selectedInterval.contains('min')) {
        minutes = int.parse(selectedInterval.split(' ')[0]);
      }

      Duration interval = Duration(hours: hours, minutes: minutes);

      // Cancel existing tasks before scheduling the new one
      await NotificationService.cancelScheduledNotification();

      // Initialize WorkManager and set the reminder
      await WorkManagerService().init();

      // Set the reminder using the selected interval
      await NotificationService.showScheduledNotificationRepeated(
          DateTime.now(), interval);
    } else {
      NotificationService.cancelScheduledNotification();
      print("notification is canceled");
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date!;
    type = widget.entryData.type!;
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);

    // Add debug print statements to trace the values
    print('Fetched entry data: ${widget.entryData.toJson()}');

    // Ensure isReminderSet is properly converted to a boolean
    isSwitch = widget.entryData.isReminderSet ?? false;

    print('Initial isSwitch value: $isSwitch');
    selectedInterval = widget.entryData.reminderInterval ?? '1 hour';
    print('Reminder interval: $selectedInterval');
  }

  @override
  void didChangeDependencies() {
    medicationsProvider =
        Provider.of<MedicationsProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkMedDuplicateData(DateTime startDate) async {
    List<MedData> existingData =
        await medicationsProvider.getMedicationRecords();
    bool duplicateExists = existingData.any((medication) =>
        medication.reminderInterval == selectedInterval &&
        medication.isReminderSet == isSwitch &&
        medication.type == type &&
        medication.date!.year == startDate.year &&
        medication.date!.month == startDate.month &&
        medication.date!.day == startDate.day &&
        medication.date!.hour == startDate.hour &&
        medication.date!.minute == startDate.minute);
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
                      "Edit Mediciation",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.medId != null) {
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
                                      medicationsProvider
                                          .deleteMedicationRecord(
                                              widget.entryData.medId!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 2),
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
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Column(
                      children: [
                        SizedBox(height: 20),
                        Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    );
                  },
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return GestureDetector(
                          onTap: () {
                            _showStartDatePicker(context, startDate);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(" Date & Time ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 13,
                                  )),
                              Text(
                                DateFormat('dd MMM yyyy  HH:mm')
                                    .format(startDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      case 1:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                  maxHeight: 35,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    items: [
                                      "Drops",
                                      "Sprays",
                                      "Pain-relief",
                                      "Anti-fever",
                                      "Anti-inflammatory",
                                      "Antibiotics",
                                      "Probiotics",
                                      "Antiseptic",
                                      "Vitamin C",
                                      "Vitamin D"
                                    ]
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
                                    value: type,
                                    onChanged: (String? value) {
                                      print('Status changed: $value');
                                      setState(() {
                                        type = value!;
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text(
                                      'choose Medication',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${type ?? 'None'}',
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        );
                      case 2:
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.notifications_active), // Changed to Icon widget
                    SizedBox(
                        width:
                            10), // Added some spacing between the icon and text
                    Text("Set Reminder"),
                    SizedBox(width: 90),
                    Switch(
                      hoverColor: Colors.blueGrey,
                      value: isSwitch,
                      onChanged: _handleSwitchChange,
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedInterval,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInterval = newValue!;
                    });
                  },
                  items: reminderIntervals.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 170,
                ),
                RoundButton(
                    onpressed: () async {
                      if (widget.entryData.medId != null) {
                        bool duplicateExists =
                            await _checkMedDuplicateData(startDate);
                        if (duplicateExists) {
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
                                    "Medication of the same type, date, and hour already exists."),
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
                          medicationsProvider.editMedicationRecord(MedData(
                              date: startDate,
                              type: type,
                              note: note,
                              isReminderSet: isSwitch,
                              reminderInterval: selectedInterval,
                              medId: widget.entryData.medId));
                          _scheduleNotification();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/change.png",
                                  height: 60,
                                  width: 60,
                                ),
                                content: Text(
                                    "Medication Data was successfully updated."),
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
              print('New DateTime: $newDateTime');
              setState(() {
                startDate = newDateTime;
                print('Updated startDate: $startDate');
                widget.onDateStratTimeChanged?.call(startDate);
              });
            },
          ),
        );
      },
    );
  }
}
