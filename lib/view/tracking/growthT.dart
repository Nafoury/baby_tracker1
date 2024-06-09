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
    super.didChangeDependencies();
    weightProvider = Provider.of<WeightProvider>(context, listen: false);
    headMeasureProvider =
        Provider.of<HeadMeasureProvider>(context, listen: false);
    heightMeasureProvider =
        Provider.of<HeightMeasureProvider>(context, listen: false);
    babyProvider = Provider.of<BabyProvider>(context, listen: false);

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

        print('Fetched head Records: $records');
      });
    } catch (e) {
      print('Error fetching baby weight records: $e');
      // Handle error here
    }
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
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                          "Growth",
                          style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          " ${babyProvider.activeBaby?.babyName ?? 'Baby'}",
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
                              Consumer<WeightProvider>(
                                  builder: (context, weightProvider, child) {
                                // Call updateHeightBoxes whenever weight records change

                                return Column(children: [
                                  Text(
                                    "Baby Weight at birth ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(babyProvider.activeBaby!.babyWeight!
                                          .toString() +
                                      "kg"),
                                  WeightChart(
                                    babyBirthDate:
                                        babyProvider.activeBaby!.dateOfBirth!,
                                    weightRecords: weightProvider.weightRecords,
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
                                      birthWeight:
                                          babyProvider.activeBaby!.babyWeight!,
                                      weightRecords:
                                          weightProvider.weightRecords)
                                ]);
                              })
                            ],
                          ),
                      ],
                    ),
                    if (selectedbutton == 1)
                      Column(children: [
                        Consumer<HeadMeasureProvider>(
                            builder: (context, headMeasureProvider, child) {
                          return Column(
                            children: [
                              Text(
                                "Baby Head circ at birth ",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(babyProvider.activeBaby!.babyhead!
                                      .toString() +
                                  "Cm"),
                              SizedBox(
                                height: 20,
                              ),
                              HeadChart(
                                  babybirth:
                                      babyProvider.activeBaby!.dateOfBirth!,
                                  measureRecords:
                                      headMeasureProvider.headRecords),
                              RoundButton(
                                  onpressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BabyHeadPage()),
                                    );
                                  },
                                  title: "Add Head circ"),
                              SizedBox(
                                height: 20,
                              ),
                              BabyHeadDataTable(
                                  birthHead: babyProvider.activeBaby!.babyhead!,
                                  measureRecords:
                                      headMeasureProvider.headRecords),
                            ],
                          );
                        }),
                      ]),
                    if (selectedbutton == 2)
                      Column(
                        children: [
                          Consumer<HeightMeasureProvider>(
                              builder: (context, heightMeasureProvider, child) {
                            return Column(
                              children: [
                                Text(
                                  "Baby Height measure at birth ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(babyProvider.activeBaby!.babyHeight!
                                        .toString() +
                                    "Cm"),
                                BabyHeightChart(
                                    babyBirth:
                                        babyProvider.activeBaby!.dateOfBirth!,
                                    heightmeasureRecords:
                                        heightMeasureProvider.heightRecords),
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
                                    babyheight:
                                        babyProvider.activeBaby!.babyHeight!,
                                    heightmeasuredata:
                                        heightMeasureProvider.heightRecords)
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
                          heightRecords: heightMeasureProvider.heightRecords,
                          headRecords: headMeasureProvider.headRecords,
                          weightRecords: weightProvider.weightRecords,
                        );
                      })
                  ]),
                ))));
  }
}
