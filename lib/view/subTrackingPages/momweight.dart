import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/weightBalance.dart';
import 'package:baba_tracker/controller/momController.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/momweightData.dart';
import 'package:baba_tracker/provider/momWeightProvider.dart';
import 'package:baba_tracker/view/tracking/momsweight.dart';

import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double mlValue = 0.0;
  MomController momController = MomController();
  DateTime startDate = DateTime.now();
  late MomWeightProvider momWeightProvider;

  @override
  void didChangeDependencies() {
    momWeightProvider = Provider.of<MomWeightProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateWeightData(DateTime date) async {
    List<MomData> existingData = await momWeightProvider.getWeightRecords();
    bool duplicateExists = existingData.any((weight) =>
        weight.weight == mlValue &&
        weight.date!.year == date.year &&
        weight.date!.month == date.month &&
        weight.date!.day == date.day);
    return duplicateExists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
                child: SafeArea(
                    child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MomWeightpage()),
                      );
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
                              height: 50, width: 50),
                          content: Text(
                            "Weight can't be zero",
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
                      await _checkDuplicateWeightData(startDate);
                  if (duplicateExists) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Image.asset("assets/images/warning.png"),
                          content: Text(
                            'Weight data of the same weight and date already exists.',
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
                    momWeightProvider.addWeightData(MomData(
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
                title: "Save Weight",
              ),
            ])))));
  }
}
