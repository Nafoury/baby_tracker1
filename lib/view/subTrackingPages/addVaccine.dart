import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/vaccinecontroller.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';

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
                        VaccineData vaccineData = VaccineData(
                            date: startDate,
                            type: status,
                            note: _note1.text,
                            babyId: sharedPref.getString("info_id"));
                        await vaccineController.saveVaccineData(
                            vaccineData: vaccineData);

                        Navigator.of(context).pop();
                      },
                      title: "Save Vaccine")
                ],
              ),
            ])))));
  }
}
