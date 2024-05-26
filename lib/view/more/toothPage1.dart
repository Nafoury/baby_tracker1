import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/teethController.dart';
import 'package:baba_tracker/models/teethModel.dart';
import 'package:baba_tracker/view/more/toothPgae.dart';
import 'package:baba_tracker/view/summary/teethDataTable.dart';
import 'package:flutter/material.dart';

class TeethWidget extends StatefulWidget {
  const TeethWidget({super.key});

  @override
  State<TeethWidget> createState() => _TeethWidgetState();
}

class _TeethWidgetState extends State<TeethWidget> {
  int selectedbutton = 0;
  DateTime startDate = DateTime.now();
  String choice = '';
  String choice2 = '';
  TeethController teethControlle = new TeethController();

  Future<bool> _checkDuplicateTeethData(DateTime startDate) async {
    List<TeethData> existingData = await teethControlle.retrieveTeethData();
    bool duplicateExists = existingData.any((teeth) =>
        teeth.lower != choice ||
        teeth.upper != choice2 &&
            teeth.date == startDate &&
            teeth.date!.year == startDate.year &&
            teeth.date!.month == startDate.month &&
            teeth.date!.day == startDate.day);
    return duplicateExists;
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
                        Navigator.pop(context);
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
                      "Teeth",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 0.05,
                ),
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
                                alignment: selectedbutton == 0
                                    ? Alignment.centerLeft
                                    : selectedbutton == 1
                                        ? Alignment.center
                                        : (selectedbutton == 2
                                            ? Alignment.centerRight
                                            : Alignment.centerRight),
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  width: (media.width * 0.4) - 30,
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
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedbutton = 0;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Baby teeth",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 0
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedbutton = 1;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Reference",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 1
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedbutton = 2;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Summary",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 2
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
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
                      const SizedBox(
                        height: 10,
                      ),
                      if (selectedbutton == 0)
                        Column(
                          children: [
                            TeethDropDown(
                              startDate: startDate,
                              choice: choice,
                              choice1: choice2,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                              onStatusChanged: (String choice) {
                                setState(() {
                                  this.choice = choice;
                                  print(choice);
                                });
                              },
                              onChoiceChanged: (String choice1) {
                                setState(() {
                                  choice2 = choice1;
                                  print(choice);
                                });
                              },
                            ),
                            SizedBox(
                              height: 300,
                            ),
                            RoundButton(
                                onpressed: () async {
                                  if (choice.isNotEmpty || choice2.isNotEmpty) {
                                    bool exisitng =
                                        await _checkDuplicateTeethData(
                                            startDate);
                                    if (exisitng) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Image.asset(
                                                "assets/images/warning.png",
                                                height: 60,
                                                width: 60),
                                            content: Text(
                                              "Teeth data already exists.",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal),
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
                                    } else {
                                      teethControlle.saveteethData(
                                          teethData: TeethData(
                                              date: startDate,
                                              upper: choice,
                                              lower: choice2));

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
                                              ' Data was successfully added',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal),
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
                                        choice = '';
                                        choice2 = '';
                                      });
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Image.asset(
                                              "assets/images/warning.png",
                                              height: 60,
                                              width: 60),
                                          content: Text(
                                            "fields can't be empty",
                                            style: TextStyle(
                                                fontStyle: FontStyle.normal),
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
                                  }
                                },
                                title: "Add teeth"),
                          ],
                        ),
                      if (selectedbutton == 1)
                        Image.asset(
                          "assets/images/teeth_jaw.jpg",
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      if (selectedbutton == 2) TeethRecordsTable()
                    ])
              ],
            ),
          ),
        )));
  }
}
