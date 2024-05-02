import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/vaccinecontroller.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:baby_tracker/provider/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddVaccine extends StatefulWidget {
  const AddVaccine({super.key});

  @override
  State<AddVaccine> createState() => _AddVaccineState();
}

class _AddVaccineState extends State<AddVaccine> {
  DateTime startDate = DateTime.now();
  final _note1 = TextEditingController();
  String status = '';
  VaccineController vaccineController = VaccineController();
  late VaccineProvider vaccineProvider;

  @override
  void didChangeDependencies() {
    vaccineProvider = Provider.of<VaccineProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkVaccineDiaperData(DateTime startDate) async {
    List<VaccineData> existingData = await vaccineProvider.getVaccineRecords();
    bool duplicateExists = existingData.any((vaccine) =>
        vaccine.type == status &&
        vaccine.date!.year == startDate.year &&
        vaccine.date!.month == startDate.month &&
        vaccine.date!.day == startDate.day &&
        vaccine.date!.hour == startDate.hour &&
        vaccine.date!.minute == startDate.minute);
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
                    "Add Vaccine",
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
                    healthType: HealthType.vaccine,
                    startDate: startDate,
                    controller: _note1,
                    status: status,
                    onDateStratTimeChanged: (DateTime newStartDate) {
                      setState(() {
                        startDate = newStartDate;
                      });
                    },
                    onNoteChanged: (String note) {
                      _note1.text = note;
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
                        if (status.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  "Vaccine can't be empty",
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
                        bool exisitngData =
                            await _checkVaccineDiaperData(startDate);
                        if (exisitngData) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png"),
                                content: Text(
                                  'Vaccine data of the same type, date, and hour already exists.',
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
                          vaccineProvider.addVaccineRecord(VaccineData(
                              date: startDate,
                              type: status,
                              note: _note1.text));
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
                                  'Vaccine Data was successfully added',
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
                            _note1.clear();
                            status = '';
                          });
                        }
                      },
                      title: "Save Vaccine")
                ],
              ),
            ])))));
  }
}
