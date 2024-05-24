import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/weightBalance.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:baba_tracker/provider/babyHeightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BabyHeightPage extends StatefulWidget {
  const BabyHeightPage({super.key});

  @override
  State<BabyHeightPage> createState() => _BabyHeightPageState();
}

class _BabyHeightPageState extends State<BabyHeightPage> {
  double mlValue = 0.0;
  DateTime startDate = DateTime.now();
  late HeightMeasureProvider heightMeasureProvider;

  @override
  void didChangeDependencies() {
    heightMeasureProvider =
        Provider.of<HeightMeasureProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateHeadCircData(DateTime startDate) async {
    List<HeightMeasureData> existingData =
        await heightMeasureProvider.getMeasureRecords();
    bool duplicateExists = existingData.any((headcirc) =>
        headcirc.date!.year == startDate.year &&
        headcirc.date!.month == startDate.month &&
        headcirc.date!.day == startDate.day);
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
                    "Add Measure",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              BalanceWeight(
                  max: 200,
                  min: 0,
                  suffix: Text(
                    "CM",
                    style: TextStyle(
                      color: Colors.blue.shade200,
                    ),
                  ),
                  startDate: startDate,
                  onStartDateChanged: (DateTime newStartDate) {
                    setState(() {
                      startDate = newStartDate;
                    });
                  },
                  onWeightChanged: (double value) {
                    setState(() {
                      mlValue = value;
                    });
                  }),
              SizedBox(
                height: 20,
              ),
              RoundButton(
                  onpressed: () async {
                    if (mlValue.isEqual(0)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Image.asset("assets/images/warning.png",
                                height: 60, width: 60),
                            content: Text(
                              "measure can't be zero",
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
                    bool duplicateExists =
                        await _checkDuplicateHeadCircData(startDate);
                    if (duplicateExists) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Image.asset("assets/images/warning.png",
                                height: 60, width: 60),
                            content: Text(
                              "You're already add height measure today",
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
                      heightMeasureProvider.addHeadData(HeightMeasureData(
                          date: startDate,
                          measure: mlValue,
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
                              'Measure head Data was successfully added',
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

                        mlValue = 0;
                      });
                    }
                  },
                  title: "Save Measure")
            ])))));
  }
}
