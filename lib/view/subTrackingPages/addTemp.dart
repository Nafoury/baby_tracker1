import 'package:baba_tracker/common_widgets/healthActivites.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/medController.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/shapes/temp3.dart';
import 'package:baba_tracker/shapes/temp4.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddTemp extends StatefulWidget {
  const AddTemp({super.key});

  @override
  State<AddTemp> createState() => _AddTempState();
}

class _AddTempState extends State<AddTemp> {
  late TempProvider tempProvider;
  DateTime startDate = DateTime.now();
  final _note = TextEditingController();
  late BabyProvider babyProvider;

  ValueNotifier<double> temperature = ValueNotifier(0.5);

  @override
  void didChangeDependencies() {
    tempProvider = Provider.of<TempProvider>(context, listen: true);
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateDiaperData(DateTime startDate) async {
    List<TempData> existingData = await tempProvider.getTempRecords();
    bool duplicateExists = existingData.any((temp) =>
        temp.temp == temperature.value &&
        temp.date!.year == startDate.year &&
        temp.date!.month == startDate.month &&
        temp.date!.day == startDate.day &&
        temp.date!.hour == startDate.hour &&
        temp.date!.minute == startDate.minute);
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
                    child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(
                    width: 75,
                  ),
                  Text(
                    "Temperature",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SliderTemperature(temperature),
                      Thermometer(temperature),
                    ],
                  ),
                  HealthWidget(
                    babybirth: babyProvider.activeBaby!.dateOfBirth!,
                    healthType: HealthType.Temp,
                    startDate: startDate,
                    controller: _note,
                    onDateStratTimeChanged: (DateTime newStartDate) {
                      setState(() {
                        startDate = newStartDate;
                      });
                    },
                    onNoteChanged: (String note) {
                      _note.text = note;
                    },
                  ),
                  SizedBox(height: 30),
                  RoundButton(
                      onpressed: () async {
                        bool duplicateExists =
                            await _checkDuplicateDiaperData(startDate);
                        if (duplicateExists) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/warning.png",
                                  height: 40,
                                  width: 40,
                                ),
                                content: Text(
                                  'temperature data of the same value, date, and hour already exists.',
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
                          tempProvider.addTempRecord(TempData(
                            date: startDate,
                            note: _note.text,
                            temp: temperature.value,
                          ));
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
                                  'temperature was successfully added',
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
                          setState(() {
                            startDate = DateTime.now();
                            _note.clear();
                            temperature = ValueNotifier(0.5);
                          });
                        }
                      },
                      title: "Save Temperature")
                ],
              ),
            ])))));
  }
}
