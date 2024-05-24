import 'package:baba_tracker/Services/notifi_service.dart';
import 'package:baba_tracker/Services/workManager.dart';
import 'package:baba_tracker/common_widgets/healthActivites.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/medController.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class AddMed extends StatefulWidget {
  const AddMed({super.key});

  @override
  State<AddMed> createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  late MedicationsProvider medicationsProvider;
  DateTime startDate = DateTime.now();
  final _note = TextEditingController();
  String status = '';
  MedController medController = MedController();
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
    '6 hours ',
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
    }
  }

  @override
  void didChangeDependencies() {
    medicationsProvider =
        Provider.of<MedicationsProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkMedicationDiaperData(DateTime startDate) async {
    List<MedData> existingData =
        await medicationsProvider.getMedicationRecords();
    bool duplicateExists = existingData.any((med) =>
        med.type == status &&
        med.date!.year == startDate.year &&
        med.date!.month == startDate.month &&
        med.date!.day == startDate.day &&
        med.date!.hour == startDate.hour &&
        med.date!.minute == startDate.minute);
    return duplicateExists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    SizedBox(
                      width: 75,
                    ),
                    Text(
                      "Add drug",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    HealthWidget(
                      healthType: HealthType.Medications,
                      startDate: startDate,
                      controller: _note,
                      status: status,
                      onDateStratTimeChanged: (DateTime newStartDate) {
                        setState(() {
                          startDate = newStartDate;
                        });
                      },
                      onNoteChanged: (String note) {
                        _note.text = note;
                      },
                      onStatusChanged: (String newstatus) {
                        setState(() {
                          status = newstatus;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(Icons.notifications_active),
                        SizedBox(width: 10),
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
                    SizedBox(height: 30),
                    RoundButton(
                        onpressed: () async {
                          if (status.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Image.asset(
                                      "assets/images/warning.png",
                                      height: 60,
                                      width: 60),
                                  content: Text(
                                    "Medication type can't be empty",
                                    style:
                                        TextStyle(fontStyle: FontStyle.normal),
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
                              await _checkMedicationDiaperData(startDate);
                          if (existingData) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Image.asset("assets/images/warning.png"),
                                  content: Text(
                                    'Medication data of the same type, date, and hour already exists.',
                                    style:
                                        TextStyle(fontStyle: FontStyle.normal),
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
                            medicationsProvider.addMedicationRecord(MedData(
                              date: startDate,
                              type: status,
                              note: _note.text,
                              isReminderSet: isSwitch,
                              reminderInterval: selectedInterval,
                            ));
                            // Schedule the notification here
                            _scheduleNotification();
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
                                    'Medication Data was successfully added',
                                    style:
                                        TextStyle(fontStyle: FontStyle.normal),
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
                            setState(() {
                              startDate = DateTime.now();
                              _note.clear();
                              status = '';
                              isSwitch = false; // Reset the switch
                            });
                          }
                        },
                        title: "Save drug"),
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
