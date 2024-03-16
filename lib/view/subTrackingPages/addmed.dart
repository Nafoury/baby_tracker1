import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/medController.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';

class AddMed extends StatefulWidget {
  const AddMed({super.key});

  @override
  State<AddMed> createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  DateTime startDate = DateTime.now();
  final _note = TextEditingController();
  String status = '';
  MedController medController = MedController();
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
                        MedData medData = MedData(
                            date: startDate, type: status, note: _note.text);

                        await medController.saveMedData(medData: medData);

                        Navigator.of(context).pop();
                      },
                      title: "Save drug")
                ],
              ),
            ])))));
  }
}
