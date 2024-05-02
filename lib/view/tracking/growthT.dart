import 'package:baby_tracker/common_widgets/boxes.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/controller/feedingBottle.dart';
import 'package:baby_tracker/controller/feedingSolids.dart';
import 'package:baby_tracker/models/babyWeight.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
import 'package:baby_tracker/provider/weightProvider.dart';
import 'package:baby_tracker/view/charts/solidschart.dart';
import 'package:baby_tracker/view/charts/weightBabyChart.dart';
import 'package:baby_tracker/view/subTrackingPages/addBabyWeight.dart';
import 'package:baby_tracker/view/subTrackingPages/momweight.dart';
import 'package:baby_tracker/view/summary/babyWeightDataTable.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:baby_tracker/view/charts/bottlechart.dart';
import 'package:baby_tracker/view/subTrackingPages/bottleView.dart';
import 'package:provider/provider.dart';

class GrowthTracking extends StatefulWidget {
  const GrowthTracking({Key? key});

  @override
  State<GrowthTracking> createState() => _GrowthTracking();
}

class _GrowthTracking extends State<GrowthTracking> {
  int selectedbutton = 0;
  late WeightProvider weightProvider;
  late BabyProvider babyProvider;
  late List<WeightData> weightRecords = [];
  double birthweight = 0;
  bool birthWeightCalculated = false;

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: false);
    super.didChangeDependencies();
    fetchWeightRecords(weightProvider);
  }

  Future<void> fetchWeightRecords(WeightProvider weightProvider) async {
    try {
      List<WeightData> records = await weightProvider.getWeightRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        weightRecords = records;
        updateWeightBoxes(records);
        print('Fetched weight Records: $records');
      });
    } catch (e) {
      print('Error fetching baby weight records: $e');
      // Handle error here
    }
  }

  void updateWeightBoxes(List<WeightData> records) {
    // Check if birth weight has been calculated and at least one record exists
    if (!birthWeightCalculated && records.isNotEmpty) {
      records.sort((a, b) => a.date!.compareTo(b.date!));
      WeightData firstRecord = records.first;

      // Calculate difference between birth weight and current weight
      double currentWeight = double.parse(firstRecord.weight.toString());
      double birthWeight = double.parse(birthweight.toString());

      double birthToCurrentDifference = currentWeight - birthWeight;
      String birthToCurrentDifferenceString =
          birthToCurrentDifference.toStringAsFixed(2);
      String birthToCurrentSign = birthToCurrentDifference >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = firstRecord.date.toString().split(" ")[0];

      setState(() {
        weightboxes[1]["weight"] = currentWeight.toString();
        weightboxes[1]["date"] = currentDate;
        weightboxes[2]["weight"] =
            "$birthToCurrentSign $birthToCurrentDifferenceString";
      });

      // Mark birth weight as calculated
      birthWeightCalculated = true;
    }

    // Check if there are at least two records to calculate change
    if (records.length >= 2) {
      records.sort((a, b) => a.date!.compareTo(b.date!));

      // Get the latest two weight records
      WeightData currentRecord = records.last;
      WeightData previousRecord = records[records.length - 2];

      // Calculate change and update weightboxes
      double currentWeight = double.parse(currentRecord.weight.toString());
      double previousWeight = double.parse(previousRecord.weight.toString());

      double change = currentWeight - previousWeight;
      String changeString = change.toStringAsFixed(2);
      String sign = change >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = currentRecord.date.toString().split(" ")[0];

      setState(() {
        weightboxes[1]["weight"] = currentWeight.toString();
        weightboxes[1]["date"] = currentDate;
        weightboxes[2]["weight"] = "$sign $changeString";
        weightboxes[2]["date"] = currentDate;
      });
    }
  }

  List weightboxes = [
    {
      "time": "At birth",
      "weight": "",
      "date": "",
    },
    {
      "time": "Current",
      "weight": "",
      "date": "",
    },
    {
      "time": "Change",
      "weight": "",
      "sign": ">",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SafeArea(
                    child: Column(children: [
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
                        "Growth",
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
                                      gradient: LinearGradient(
                                          colors: Tcolor.primaryG),
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
                                              "Weight",
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
                                              "Height",
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
                                              "Head",
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
                              Consumer<BabyProvider>(
                                builder: (context, babyProvider, _) {
                                  if (babyProvider.babyRecords.isNotEmpty) {
                                    // Extract birthdate and weight at birth
                                    String birthdate = babyProvider
                                        .babyRecords.first.dateOfBirth!
                                        .toString();
                                    birthweight = babyProvider
                                        .babyRecords.first.babyWeight!
                                        .toDouble();

                                    // Update "At birth" box with birthdate and weight at birth
                                    weightboxes[0]["date"] =
                                        birthdate.toString().split(" ")[0];
                                    weightboxes[0]["weight"] =
                                        birthweight.toString();
                                  }
                                  // Return the UI components
                                  return SizedBox(); // Return a placeholder widget if needed
                                },
                              ),
                              Consumer<WeightProvider>(
                                  builder: (context, weightProvider, child) {
                                return Column(children: [
                                  SizedBox(
                                    height: media.width * 0.3,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: weightboxes.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                            width:
                                                20); // Adjust the width as needed
                                      },
                                      itemBuilder: (context, index) {
                                        var aobj =
                                            weightboxes[index] as Map? ?? {};
                                        return Boxes(
                                            aobj: aobj,
                                            weightboxes: weightboxes.cast());
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  WeightChart(
                                    weightRecords: weightRecords,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RoundButton(
                                      onpressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BabyWeightPage()),
                                        );
                                      },
                                      title: "Add Weight"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BabyWeightDataTable(
                                      weightRecords: weightRecords)
                                ]);
                              })
                            ],
                          )
                      ])
                ])))));
  }
}
