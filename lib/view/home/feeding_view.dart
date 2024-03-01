import 'dart:ffi';
import 'package:baby_tracker/common_widgets/notebutton.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/nursingbuttons.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/common_widgets/babybottle.dart';
import 'package:get/get.dart';
import 'package:baby_tracker/common_widgets/volumebottle.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/controller/feedingBottle.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:baby_tracker/view/summary/bottleSummary.dart';
import 'package:baby_tracker/controller/feedingSolids.dart';

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
  final _note = TextEditingController();
  BottleController bottleController = BottleController();
  List<BottleData> bottleRecords = [];
  final _fruit = TextEditingController();
  final _protein = TextEditingController();
  final _grain = TextEditingController();
  final _dairy = TextEditingController();
  final _veg = TextEditingController();
  int? fruit;
  int? grains;
  int? protein;
  int? veg;
  int? dairy;
  SolidsController solidsController = SolidsController();

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
                      if (selectedbutton == 0) RoundButton1(),
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
                              controller: _note,
                              startDate: startDate,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                              onNoteChanged: (String note) {
                                _note.text = note;
                              },
                            ),
                            SizedBox(height: 90),
                            RoundButton(
                              onpressed: () async {
                                if (mlValue.isEqual(0)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text('You have to fill the bottle'),
                                        content:
                                            Text("Liquied amount is required"),
                                      );
                                    },
                                  );
                                  return;
                                }

                                BottleData bottleData = BottleData(
                                    startDate: startDate,
                                    amount: mlValue,
                                    note: _note.text,
                                    babyId: sharedPref.getString("info_id"));
                                await bottleController.savebottlerData(
                                    bottleData: bottleData);

                                Navigator.of(context).pop();
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
                              controller: _note,
                              controller1: _fruit,
                              controller2: _veg,
                              controller3: _grain,
                              controller4: _protein,
                              controller5: _dairy,
                              onDateStratTimeChanged: (DateTime newStartDate) {
                                setState(() {
                                  startDate = newStartDate;
                                });
                              },
                              onNoteChanged: (String note) {
                                _note.text = note;
                              },
                              onDairyChanged: (int value) {
                                dairy = value;
                              },
                              onFruitChanged: (int value) {
                                fruit = value;
                              },
                              onGrainsChanged: (int value) {
                                grains = value;
                              },
                              onProteinChanged: (int value) {
                                protein = value;
                              },
                            ),
                            SizedBox(height: 50),
                            RoundButton(
                              onpressed: () async {
                                SolidsData solidsData = SolidsData(
                                  date: startDate,
                                  note: _note.text,
                                  dairy: dairy,
                                  fruits: fruit,
                                  grains: grains,
                                  protein: protein,
                                );
                                int totalAmount = (fruit ?? 0) +
                                    (veg ?? 0) +
                                    (protein ?? 0) +
                                    (grains ?? 0) +
                                    (dairy ?? 0);

                                // Add your condition here
                                if (totalAmount < 15 || totalAmount > 700) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                          "Total amount should be between 15g and 700g.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  return;
                                }

                                await solidsController.savebottlerData(
                                    solidsData: solidsData);

                                _note.clear();
                                _fruit.clear();
                                _veg.clear();
                                _grain.clear();
                                _protein.clear();
                                _dairy.clear();
                              },
                              title: "Save feed",
                            )
                          ],
                        ),
                      if (selectedbutton == 3)
                        FutureBuilder(
                          future: Future.wait([
                            bottleController.retrieveBottleData(),
                            solidsController.retrieveSolidsData(),
                          ]),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Text("Loading..."));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              List<BottleData> bottleRecords =
                                  (snapshot.data![0] as List)
                                      .cast<BottleData>();
                              List<SolidsData> solidsRecords =
                                  (snapshot.data![1] as List)
                                      .cast<SolidsData>();

                              return FeedingSummaryTable(
                                bottleRecords: bottleRecords,
                                solidsRecrods: solidsRecords,
                              );
                            } else {
                              return Text('No data available.');
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ))),
        ));
  }
}
