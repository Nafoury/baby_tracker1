import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:baby_tracker/view/summary/diaperDataTable.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DiaperChange extends StatefulWidget {
  const DiaperChange({Key? key});

  @override
  State<DiaperChange> createState() => _DiaperChangeState();
}

class _DiaperChangeState extends State<DiaperChange> {
  int selectedButton = 0;
  DateTime startDate = DateTime.now();
  String status = '';
  final _note = TextEditingController();
  late DiaperProvider diaperProvider;

  @override
  void didChangeDependencies() {
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(width: 85),
                    Text(
                      "Diaper",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 0.05),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Tcolor.lightgray,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: (media.width * 0.9),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedContainer(
                                alignment: selectedButton == 0
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: (media.width * 0.5) - 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: Tcolor.primaryG),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedButton = 0;
                                          });
                                        },
                                        child: Container(
                                          child: Text(
                                            "Diaper",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: selectedButton == 0
                                                  ? Tcolor.white
                                                  : Tcolor.gray,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedButton = 1;
                                          });
                                        },
                                        child: Container(
                                          child: Text(
                                            "Summary",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: selectedButton == 1
                                                  ? Tcolor.white
                                                  : Tcolor.gray,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (selectedButton == 0)
                        Column(
                          children: [
                            TrackingWidget(
                              trackingType: TrackingType.Diaper,
                              controller: _note,
                              startDate: startDate,
                              status: status,
                              onStatusChanged: (String newStatus) {
                                setState(() {
                                  status = newStatus;
                                });
                              },
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                              onNoteChanged: (String note) {
                                _note.text = note;
                              },
                            ),
                            SizedBox(height: 300),
                            RoundButton(
                              onpressed: () async {
                                if (status.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Status is empty'),
                                        content: Text("Status is required"),
                                      );
                                    },
                                  );
                                  return;
                                }

                                diaperProvider.addDiaperData(DiaperData(
                                  startDate: startDate,
                                  note: _note.text,
                                  status: status,
                                ));

                                setState(() {
                                  startDate = DateTime.now();
                                  _note.clear();
                                  status = '';
                                });
                              },
                              title: "Save change",
                            ),
                          ],
                        ),
                      if (selectedButton == 1) DiaperDataTable(),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
