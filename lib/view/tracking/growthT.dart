import 'package:baba_tracker/common_widgets/boxes.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/provider/babyHeadProvider.dart';
import 'package:baba_tracker/provider/babyHeightProvider.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/weightProvider.dart';
import 'package:baba_tracker/view/charts/babyHeightChart.dart';
import 'package:baba_tracker/view/charts/headBabyChart.dart';
import 'package:baba_tracker/view/charts/weightBabyChart.dart';
import 'package:baba_tracker/view/subTrackingPages/addBabyWeight.dart';
import 'package:baba_tracker/view/subTrackingPages/addHeadMeasure.dart';
import 'package:baba_tracker/view/subTrackingPages/addHeight.dart';
import 'package:baba_tracker/view/summary/babyHeadCicTable.dart';
import 'package:baba_tracker/view/summary/babyHeightTable.dart';
import 'package:baba_tracker/view/summary/babyWeightDataTable.dart';
import 'package:baba_tracker/view/summary/growthTable.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GrowthTracking extends StatefulWidget {
  const GrowthTracking({Key? key});

  @override
  State<GrowthTracking> createState() => _GrowthTracking();
}

class _GrowthTracking extends State<GrowthTracking> {
  int selectedbutton = 0;
  late WeightProvider weightProvider;
  late HeadMeasureProvider headMeasureProvider;
  late HeightMeasureProvider heightMeasureProvider;
  late BabyProvider babyProvider;
  late List<WeightData> weightRecords = [];
  late List<MeasureData> headRecords = [];
  late List<HeightMeasureData> heightRecords = [];
  double birthweight = 0;
  double birthHeadMeasure = 0;
  double birthHeightMeasure = 0;
  bool birthWeightCalculated = false;
  bool birthHeadCalculated = false;
  bool birthHeightCalculated = false;

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: false);
    headMeasureProvider =
        Provider.of<HeadMeasureProvider>(context, listen: false);
    heightMeasureProvider =
        Provider.of<HeightMeasureProvider>(context, listen: false);
    super.didChangeDependencies();
    fetchWeightRecords(weightProvider);
    fetchHeadRecords(headMeasureProvider);
    fetchHeightRecords(heightMeasureProvider);
  }

  Future<void> fetchHeightRecords(
      HeightMeasureProvider heightMeasureProvider) async {
    try {
      List<HeightMeasureData> records =
          await heightMeasureProvider.getMeasureRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        heightRecords = records;
        updateHeightBoxes(records);
        print('Fetched weight Records: $records');
      });
    } catch (e) {
      print('Error fetching baby weight records: $e');
      // Handle error here
    }
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

  Future<void> fetchHeadRecords(HeadMeasureProvider headMeasureProvider) async {
    try {
      List<MeasureData> records = await headMeasureProvider.getMeasureRecords();
      print('Fetched head circ Records: $records');
      setState(() {
        headRecords = records;
        updateHeadBoxes(records);

        print('Fetched head Records: $records');
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

  void updateHeadBoxes(List<MeasureData> records) {
    // Check if birth weight has been calculated and at least one record exists
    if (!birthHeadCalculated && records.isNotEmpty) {
      records.sort((a, b) => a.date!.compareTo(b.date!));
      MeasureData firstRecord = records.first;

      // Calculate difference between birth weight and current weight
      double currentWeight = double.parse(firstRecord.measure.toString());
      double birthHead = double.parse(birthHeadMeasure.toString());

      double birthToCurrentDifference = currentWeight - birthHead;
      String birthToCurrentDifferenceString =
          birthToCurrentDifference.toStringAsFixed(2);
      String birthToCurrentSign = birthToCurrentDifference >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = firstRecord.date.toString().split(" ")[0];

      setState(() {
        headboxes[1]["weight"] = currentWeight.toString();
        headboxes[1]["date"] = currentDate;
        headboxes[2]["weight"] =
            "$birthToCurrentSign $birthToCurrentDifferenceString";
      });

      // Mark birth weight as calculated
      birthHeadCalculated = true;
    }

    // Check if there are at least two records to calculate change
    if (records.length >= 2) {
      records.sort((a, b) => a.date!.compareTo(b.date!));

      // Get the latest two weight records
      MeasureData currentRecord = records.last;
      MeasureData previousRecord = records[records.length - 2];

      // Calculate change and update weightboxes
      double currentWeight = double.parse(currentRecord.measure.toString());
      double previousWeight = double.parse(previousRecord.measure.toString());

      double change = currentWeight - previousWeight;
      String changeString = change.toStringAsFixed(2);
      String sign = change >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = currentRecord.date.toString().split(" ")[0];

      setState(() {
        headboxes[1]["weight"] = currentWeight.toString();
        headboxes[1]["date"] = currentDate;
        headboxes[2]["weight"] = "$sign $changeString";
        headboxes[2]["date"] = currentDate;
      });
    }
  }

  void updateHeightBoxes(List<HeightMeasureData> records) {
    // Check if birth weight has been calculated and at least one record exists
    if (!birthHeightCalculated && records.isNotEmpty) {
      records.sort((a, b) => a.date!.compareTo(b.date!));
      HeightMeasureData firstRecord = records.first;

      // Calculate difference between birth weight and current weight
      double currentWeight = double.parse(firstRecord.measure.toString());
      double birthHead = double.parse(birthHeadMeasure.toString());

      double birthToCurrentDifference = currentWeight - birthHead;
      String birthToCurrentDifferenceString =
          birthToCurrentDifference.toStringAsFixed(2);
      String birthToCurrentSign = birthToCurrentDifference >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = firstRecord.date.toString().split(" ")[0];

      setState(() {
        heightboxes[1]["weight"] = currentWeight.toString();
        heightboxes[1]["date"] = currentDate;
        heightboxes[2]["weight"] =
            "$birthToCurrentSign $birthToCurrentDifferenceString";
      });

      // Mark birth weight as calculated
      birthHeightCalculated = true;
    }

    // Check if there are at least two records to calculate change
    if (records.length >= 2) {
      records.sort((a, b) => a.date!.compareTo(b.date!));

      // Get the latest two weight records
      HeightMeasureData currentRecord = records.last;
      HeightMeasureData previousRecord = records[records.length - 2];

      // Calculate change and update weightboxes
      double currentWeight = double.parse(currentRecord.measure.toString());
      double previousWeight = double.parse(previousRecord.measure.toString());

      double change = currentWeight - previousWeight;
      String changeString = change.toStringAsFixed(2);
      String sign = change >= 0 ? "+" : "-";

      // Extract date part from the DateTime object
      String currentDate = currentRecord.date.toString().split(" ")[0];

      setState(() {
        heightboxes[1]["weight"] = currentWeight.toString();
        heightboxes[1]["date"] = currentDate;
        heightboxes[2]["weight"] = "$sign $changeString";
        heightboxes[2]["date"] = currentDate;
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
  List headboxes = [
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
  List heightboxes = [
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
                                              "Head",
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
                                              "Height",
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
                                            .activeBaby?.dateOfBirth
                                            .toString() ??
                                        '';
                                    birthweight =
                                        babyProvider.activeBaby?.babyWeight ??
                                            0;

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
                          ),
                        if (selectedbutton == 1)
                          Column(children: [
                            Consumer<BabyProvider>(
                              builder: (context, babyProvider, _) {
                                if (babyProvider.babyRecords.isNotEmpty) {
                                  // Extract birthdate and weight at birth
                                  String birthdate = babyProvider
                                          .activeBaby?.dateOfBirth
                                          .toString() ??
                                      '';
                                  birthHeadMeasure =
                                      babyProvider.activeBaby?.babyhead ?? 0;

                                  // Update "At birth" box with birthdate and weight at birth
                                  headboxes[0]["date"] =
                                      birthdate.toString().split(" ")[0];
                                  headboxes[0]["weight"] =
                                      birthHeadMeasure.toString();
                                }
                                // Return the UI components
                                return SizedBox(); // Return a placeholder widget if needed
                              },
                            ),
                            Consumer<HeadMeasureProvider>(
                                builder: (context, headMeasureProvider, child) {
                              return Column(
                                children: [
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
                                            headboxes[index] as Map? ?? {};
                                        return Boxes(
                                            aobj: aobj,
                                            weightboxes: headboxes.cast());
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  HeadChart(measureRecords: headRecords),
                                  RoundButton(
                                      onpressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BabyHeadPage()),
                                        );
                                      },
                                      title: "Add Head circ"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BabyHeadDataTable(
                                      measureRecords: headRecords),
                                ],
                              );
                            }),
                          ]),
                        if (selectedbutton == 2)
                          Column(
                            children: [
                              Consumer<BabyProvider>(
                                builder: (context, babyProvider, _) {
                                  if (babyProvider.babyRecords.isNotEmpty) {
                                    // Extract birthdate and weight at birth
                                    String birthdate = babyProvider
                                            .activeBaby?.dateOfBirth
                                            .toString() ??
                                        '';
                                    birthHeightMeasure =
                                        babyProvider.activeBaby?.babyHeight ??
                                            0;

                                    // Update "At birth" box with birthdate and weight at birth
                                    heightboxes[0]["date"] =
                                        birthdate.toString().split(" ")[0];
                                    heightboxes[0]["weight"] =
                                        birthHeightMeasure.toString();
                                  }
                                  // Return the UI components
                                  return SizedBox(); // Return a placeholder widget if needed
                                },
                              ),
                              Consumer<HeightMeasureProvider>(builder:
                                  (context, heightMeasureProvider, child) {
                                return Column(
                                  children: [
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
                                              heightboxes[index] as Map? ?? {};
                                          return Boxes(
                                              aobj: aobj,
                                              weightboxes: heightboxes.cast());
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    BabyHeightChart(
                                        heightmeasureRecords: heightRecords),
                                    RoundButton(
                                        onpressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BabyHeightPage()),
                                          );
                                        },
                                        title: "Add height measure"),
                                    BabyHeightDataTable(
                                        heightmeasuredata: heightRecords)
                                  ],
                                );
                              })
                            ],
                          ),
                        if (selectedbutton == 3)
                          Consumer3<HeightMeasureProvider, HeadMeasureProvider,
                                  WeightProvider>(
                              builder: (context, heightMeasureProvider,
                                  headmeasureprovider, weightProvider, child) {
                            return GrowthSummaryTable(
                              heightRecords:
                                  heightMeasureProvider.heightRecords,
                              headRecords: headMeasureProvider.headRecords,
                              weightRecords: weightProvider.weightRecords,
                            );
                          })
                      ]),
                ])))));
  }
}
