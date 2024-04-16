import 'package:baby_tracker/Services/notifi_service.dart';
import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/medController.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:baby_tracker/provider/medications_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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

  // Define list of reminder intervals
  final List<String> reminderIntervals = [
    '1 hour',
    '1 hour 30 min',
    '2 hours',
    '2 hour 30 min',
    '3 hours',
    '3 hour 30 min',
    '4 hours',
    '6 hours ',
    '12 hours'
    // Add more intervals as needed
  ];

  String selectedInterval = '1 hour'; // Default selected interval

  @override
  void didChangeDependencies() {
    medicationsProvider =
        Provider.of<MedicationsProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
                child: SafeArea(
                    child: Column(children: [
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
                  RoundButton(
                      onpressed: () async {
                        medicationsProvider.addMedicationRecord(MedData(
                          date: startDate,
                          type: status,
                          note: _note.text,
                        ));
                      },
                      title: "Save drug"),
                  SizedBox(height: 30),
                  ListTile(
                    onTap: () {
                      NotificationService.showBasicNotification();
                    },
                    leading: Icon(Icons.notifications),
                    title: Text('Set Reminder'),
                  ),
                  // Display dropdown button for selecting reminder interval
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
                  // Button to set the reminder
                  TextButton(
                    onPressed: () async {
                      // Convert selected interval to Duration
                      int hours = int.parse(selectedInterval.split(' ')[0]);
                      int minutes = selectedInterval.contains('hour') ? 0 : 30;
                      Duration interval =
                          Duration(hours: hours, minutes: minutes);

                      // Set the reminder using the selected interval
                      await NotificationService.showScheduledNotification(
                          startDate, interval);
                      print(startDate);
                      print(interval);
                    },
                    child: Text('Set Reminder'),
                  )
                ],
              ),
            ])))));
  }
}
