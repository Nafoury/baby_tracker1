import 'dart:ffi';

import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/common_widgets/babybottle.dart';
import 'package:get/get.dart';
import 'package:baby_tracker/common_widgets/volumebottle.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/controller/feedingBottle.dart';

import 'dart:math' as math;

class FeedingView extends StatefulWidget {
  const FeedingView({Key? key});

  @override
  State<FeedingView> createState() => _FeedingViewState();
}

class _FeedingViewState extends State<FeedingView> {
  int selectedbutton = 0;
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  double mlValue = 0.0;
  String note = '';
  BottleController bottleController = BottleController();

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
                        "Feeding",
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
                                        ? Alignment.centerLeft +
                                            const Alignment(0.7, 0)
                                        : (selectedbutton == 2
                                            ? Alignment.centerRight -
                                                const Alignment(0.7, 0)
                                            : (selectedbutton == 3
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft)),
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  width: (media.width * 0.3) - 30,
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
                                            "Nursing",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 0
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 14,
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
                                            "Bottle",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 1
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 14,
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
                                            "Solids",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: selectedbutton == 2
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedbutton = 3;
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
                                                color: selectedbutton == 3
                                                    ? Tcolor.white
                                                    : Tcolor.gray,
                                                fontSize: 14,
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
                        height: 20,
                      ),
                      if (selectedbutton == 0)
                        Column(
                          children: [
                            TrackingWidget(
                              trackingType: TrackingType.Feeding,
                              feedingSubtype: FeedingSubtype.nursing,
                              startDate: startDate,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                            ),
                            SizedBox(height: 50),
                            RoundButton(
                              onpressed: () async {},
                              title: "save feed",
                            )
                          ],
                        ),
                      if (selectedbutton == 1)
                        Column(
                          children: [
                            BabyBottleSelector(
                                onMlValueChanged: (double value) {
                              setState(() {
                                mlValue = value;
                              });
                            }),
                            SizedBox(height: 20),
                            TrackingWidget(
                              trackingType: TrackingType.Feeding,
                              feedingSubtype: FeedingSubtype.bottle,
                              startDate: startDate,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                            ),
                            SizedBox(height: 90),
                            RoundButton(
                              onpressed: () async {
                                print("mlValue: $mlValue");
                                print("note: $note");
                                BottleData bottleData = BottleData(
                                    date: startDate,
                                    amount: mlValue,
                                    note: note,
                                    id: sharedPref.getString("info_id") ?? "");
                                await bottleController.savebottlerData(
                                    bottleData: bottleData);
                              },
                              title: "save feed",
                            )
                          ],
                        ),
                      if (selectedbutton == 2)
                        Column(
                          children: [
                            TrackingWidget(
                              trackingType: TrackingType.Feeding,
                              feedingSubtype: FeedingSubtype.solids,
                              startDate: startDate,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                            ),
                            SizedBox(height: 50),
                            RoundButton(
                              onpressed: () async {},
                              title: "save feed",
                            )
                          ],
                        )
                    ],
                  ),
                ],
              ))),
        ));
  }
}
