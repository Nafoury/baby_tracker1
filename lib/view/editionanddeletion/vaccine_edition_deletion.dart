import 'dart:ffi';
import 'package:baba_tracker/Services/notifi_service.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/vaccineData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VaccineEdit extends StatefulWidget {
  final VaccineData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  VaccineEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _VaccineEditState createState() => _VaccineEditState();
}

class _VaccineEditState extends State<VaccineEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late String type;
  late String note;
  late TextEditingController noteController;
  late VaccineProvider vaccineProvider;
  late BabyProvider babyProvider;
  bool isSwitch = false;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    type = widget.entryData.type.toString();
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);
    isSwitch = widget.entryData.isReminderSet ?? false;
  }

  @override
  void didChangeDependencies() {
    vaccineProvider = Provider.of<VaccineProvider>(context, listen: false);
    babyProvider = Provider.of<BabyProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> _checkVaccineDDuplicateData(DateTime startDate) async {
    List<VaccineData> existingData = await vaccineProvider.getVaccineRecords();
    bool duplicateExists = existingData.any((vaccine) =>
        vaccine.isReminderSet == isSwitch &&
        vaccine.type == type &&
        vaccine.date!.year == startDate.year &&
        vaccine.date!.month == startDate.month &&
        vaccine.date!.day == startDate.day &&
        vaccine.date!.hour == startDate.hour &&
        vaccine.date!.minute == startDate.minute);
    return duplicateExists;
  }

  void _scheduleNotification() async {
    if (isSwitch) {
      if (startDate!.isBefore(DateTime.now())) {
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
                'Reminder can\'t be set for the past. It should be scheduled for a future time.',
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

      if (isSwitch && startDate!.isAfter(DateTime.now())) {
        NotificationService.showSchduledNotification1(startDate!, type);
      }
    } else {
      NotificationService.cancelScheduledNotification();
    }
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
                      "Edit Vaccine",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.vaccineId != null) {
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
                                      vaccineProvider.deleteVaccineRecord(
                                          widget.entryData.vaccineId!);
                                      if (widget.entryData.isReminderSet !=
                                          null) {
                                        await NotificationService
                                            .cancelScheduledNotification();
                                        print("notfication is cancelled also");
                                      }
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
                            _showStartDatePicker(context, startDate!);
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
                                    .format(startDate!),
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
                                      "HepB (Hepatitis B)",
                                      "DTaP (Diphtheria, Tetanus, Pertussis)",
                                      "IPV (Inactivated Poliovirus)",
                                      "Hib (Haemophilus influenza type b)",
                                      "MMR (Meales, Mumps , Rubella)",
                                      "HepA (Hepatitis A)",
                                      "Varicella  (Chicken pox)",
                                      "RV (Rortavirus)",
                                      "PCV (Pneumococcal)",
                                      "Influenza",
                                      "Encephalities",
                                      "TB",
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
                    Text("Set Reminder"),
                    Switch(
                      hoverColor: Colors.blueGrey,
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                ),
                RoundButton(
                    onpressed: () async {
                      if (widget.entryData.vaccineId != null) {
                        bool duplicateExists =
                            await _checkVaccineDDuplicateData(startDate!);
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
                                    "Vaccine of the same type, date, and hour already exists."),
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
                          _scheduleNotification();
                          vaccineProvider.editVaccineRecord(VaccineData(
                              date: startDate,
                              type: type,
                              note: note,
                              isReminderSet: isSwitch,
                              vaccineId: widget.entryData.vaccineId!));
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
                                    "Vaccine Data was successfully updated."),
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
    DateTime minimumDateTime = babyProvider.activeBaby!.dateOfBirth!;
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
                widget.onDateStratTimeChanged?.call(startDate!);
              });
            },
          ),
        );
      },
    );
  }
}
