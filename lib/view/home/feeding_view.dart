import 'dart:ffi';
import 'package:baba_tracker/common_widgets/notebutton.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/nursingbuttons.dart';
import 'package:baba_tracker/controller/feedNursing.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/models/solidsData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/bottleDataProvider.dart';
import 'package:baba_tracker/provider/nursingDataProvider.dart';
import 'package:baba_tracker/provider/solids_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:baba_tracker/common_widgets/addingactivites.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:baba_tracker/common_widgets/volumebottle.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/controller/feedingBottle.dart';
import 'package:baba_tracker/view/summary/bottleSummary.dart';
import 'package:baba_tracker/controller/feedingSolids.dart';
import 'package:provider/provider.dart';

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
  NursingController nursingController = NursingController();
  late SolidsProvider solidsProvider;
  late NursingDataProvider nursingDataProvider;
  late BottleDataProvider bottleDataProvider;
  late BabyProvider babyProvider;

  Future<void> fetchBottleData(BottleDataProvider bottleDataProvider) async {
    try {
      List<BottleData> record = await bottleDataProvider.getBottleRecords();
      print('Fetched bottle Records: $record');
      setState(() {
        bottleRecords = record;
        print('Fetched bottle Records: $record');
      });
    } catch (e) {
      print('Error fetching bottle records: $e');
      // Handle error here
    }
  }

  @override
  void didChangeDependencies() {
    solidsProvider = Provider.of<SolidsProvider>(context, listen: true);
    bottleDataProvider = Provider.of<BottleDataProvider>(context, listen: true);
    nursingDataProvider =
        Provider.of<NursingDataProvider>(context, listen: true);
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateBottleData(DateTime startDate) async {
    List<BottleData> existingData = await bottleDataProvider.getBottleRecords();
    bool duplicateExists = existingData.any((bottle) =>
        bottle.amount == mlValue &&
        bottle.startDate!.year == startDate.year &&
        bottle.startDate!.month == startDate.month &&
        bottle.startDate!.day == startDate.day &&
        bottle.startDate!.hour == startDate.hour &&
        bottle.startDate!.minute == startDate.minute);
    return duplicateExists;
  }

  Future<bool> _checkDuplicateSolidsData(DateTime startDate) async {
    List<SolidsData> existingData = await solidsProvider.getSolidsRecords();
    bool duplicateExists = existingData.any((solids) =>
        solids.fruits == fruit &&
        solids.veg == veg &&
        solids.protein == protein &&
        solids.grains == grains &&
        solids.dairy == dairy &&
        solids.date!.year == startDate.year &&
        solids.date!.month == startDate.month &&
        solids.date!.day == startDate.day &&
        solids.date!.hour == startDate.hour &&
        solids.date!.minute == startDate.minute);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        "Feeding",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        " ${babyProvider.activeBaby?.babyName ?? 'Baby'}", // Access active baby's name
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
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
                        Column(children: [
                          BabyBottleSelector(onMlValueChanged: (double value) {
                            setState(() {
                              mlValue = value;
                            });
                          }),
                          SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TrackingWidget(
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
                          ),
                          SizedBox(height: 90),
                          RoundButton(
                            onpressed: () async {
                              if (mlValue.isEqual(0)) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Image.asset(
                                          "assets/images/warning.png",
                                          height: 60,
                                          width: 60),
                                      content: Text(
                                        "liquied amount can't be empty",
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
                                return;
                              }
                              bool duplicateExists =
                                  await _checkDuplicateBottleData(startDate);
                              if (duplicateExists) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Image.asset(
                                          height: 50,
                                          width: 50,
                                          "assets/images/warning.png"),
                                      content: Text(
                                        'Bottle data of the same amount, date, and hour already exists.',
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
                                return;
                              } else {
                                bottleDataProvider.addBottleData(BottleData(
                                    startDate: startDate,
                                    amount: mlValue,
                                    note: _note.text,
                                    babyId: sharedPref.getString("info_id")));

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
                                        'Bottle Data was successfully added',
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
                                  startDate = DateTime.now();
                                  _note.clear();
                                  mlValue = 0;
                                });
                              }
                            },
                            title: "Save Feed",
                          ),
                        ]),
                      if (selectedbutton == 2)
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TrackingWidget(
                                  trackingType: TrackingType.Feeding,
                                  feedingSubtype: FeedingSubtype.solids,
                                  startDate: startDate,
                                  controller: _note,
                                  controller1: _fruit,
                                  controller2: _veg,
                                  controller3: _grain,
                                  controller4: _protein,
                                  controller5: _dairy,
                                  onDateStratTimeChanged:
                                      (DateTime newStartDate) {
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
                                  onVegChanged: (int value) {
                                    veg = value;
                                  }),
                            ),
                            SizedBox(height: 50),
                            RoundButton(
                              onpressed: () async {
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
                                        title: Image.asset(
                                            height: 70,
                                            width: 70,
                                            "assets/images/warning.png"),
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
                                bool duplicateExists =
                                    await _checkDuplicateSolidsData(startDate);
                                if (duplicateExists) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Image.asset(
                                            height: 50,
                                            width: 50,
                                            "assets/images/warning.png"),
                                        content: Text(
                                          'Solids data of the same amount, date, and hour already exists.',
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
                                  return;
                                } else {
                                  solidsProvider.addSolidsData(SolidsData(
                                      date: startDate,
                                      note: _note.text,
                                      dairy: dairy,
                                      fruits: fruit,
                                      grains: grains,
                                      protein: protein,
                                      veg: veg));

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
                                          'Solids Data was successfully added',
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
                                    _note.clear();
                                    _fruit.clear();
                                    _veg.clear();
                                    _grain.clear();
                                    _protein.clear();
                                    _dairy.clear();
                                  });
                                }
                              },
                              title: "Save Feed",
                            ),
                          ],
                        ),
                      if (selectedbutton == 3)
                        Consumer3<BottleDataProvider, SolidsProvider,
                                NursingDataProvider>(
                            builder: (context, bottleDataProvider,
                                solidsProvider, nursingDataProvider, child) {
                          return FeedingSummaryTable(
                            bottleRecords: bottleDataProvider.bottleRecords,
                            solidsRecrods: solidsProvider.solidsRecords,
                            nursingRecords: nursingDataProvider.nursingRecords,
                          );
                        })
                    ],
                  ),
                ],
              ))),
        ));
  }
}
