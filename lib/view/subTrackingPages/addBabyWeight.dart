import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/weightBalance.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/weightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BabyWeightPage extends StatefulWidget {
  const BabyWeightPage({super.key});

  @override
  State<BabyWeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<BabyWeightPage> {
  double mlValue = 0.0;

  DateTime startDate = DateTime.now();
  late WeightProvider weightProvider;
  late BabyProvider babyProvider;

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: true);
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateHeadCircData(DateTime startDate) async {
    List<WeightData> existingData = await weightProvider.getWeightRecords();
    bool duplicateExists = existingData.any((weightData) =>
        weightData.date!.year == startDate.year &&
        weightData.date!.month == startDate.month &&
        weightData.date!.day == startDate.day);
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
                    "Add Weight",
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
                  userBirthDate: babyProvider.activeBaby!.dateOfBirth!,
                  initialWeight: mlValue,
                  max: 200,
                  min: 0,
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
                              "weight can't be zero",
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
                              'Weight data of the same date already exists.',
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
                      weightProvider.addWeightData(WeightData(
                          date: startDate,
                          weight: mlValue,
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
                              'Weight Data was successfully added',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                  title: "Save Weight")
            ])))));
  }
}
