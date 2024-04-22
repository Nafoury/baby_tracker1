import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/teethController.dart';
import 'package:baby_tracker/models/teethModel.dart';
import 'package:baby_tracker/view/more/toothPgae.dart';
import 'package:baby_tracker/view/summary/teethDataTable.dart';
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
                      onPressed: () {},
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
                              height: 150,
                            ),
                            RoundButton(
                                onpressed: () {
                                  teethControlle.saveteethData(
                                      teethData: TeethData(
                                          date: startDate,
                                          upper: choice,
                                          lower: choice2));
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
