import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/feedNursing.dart';
import 'package:baby_tracker/controller/feedingBottle.dart';
import 'package:baby_tracker/controller/feedingSolids.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/models/nursingData.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:baby_tracker/provider/bottleDataProvider.dart';
import 'package:baby_tracker/provider/nursingDataProvider.dart';
import 'package:baby_tracker/provider/solids_provider.dart';
import 'package:baby_tracker/view/charts/nursingchart.dart';
import 'package:baby_tracker/view/charts/solidschart.dart';
import 'package:baby_tracker/view/summary/bottleDataTable.dart';
import 'package:baby_tracker/view/summary/nursingDataTabe.dart';
import 'package:baby_tracker/view/summary/solidsDataTable.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:baby_tracker/view/charts/bottlechart.dart';
import 'package:baby_tracker/view/subTrackingPages/bottleView.dart';
import 'package:provider/provider.dart';

class FeedingTracking extends StatefulWidget {
  const FeedingTracking({Key? key});

  @override
  State<FeedingTracking> createState() => _FeedingTracking();
}

class _FeedingTracking extends State<FeedingTracking> {
  int selectedbutton = 0;
  BottleController bottleController = BottleController();
  SolidsController solidsController = SolidsController();
  NursingController nursingController = NursingController();

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
                                          ? Alignment.center
                                          : (selectedbutton == 2
                                              ? Alignment.centerRight
                                              : Alignment.centerRight),
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    width: (media.width * 0.4) - 35,
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
                          Consumer<NursingDataProvider>(
                            builder: (context, nursingDataProvider, child) {
                              List<NusringData> nursingRecords =
                                  nursingDataProvider.nursingRecords;
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Overview',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ),
                                  NursingHeatmap(
                                    nursingData: nursingRecords,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    height: 80,
                                  ),
                                  NursingDataTable(
                                      nursingRecords: nursingRecords)
                                ],
                              );
                            },
                          ),
                        if (selectedbutton == 1)
                          Consumer<BottleDataProvider>(
                            builder: (context, bottleDataProvider, child) {
                              List<BottleData> bottlesRecords =
                                  bottleDataProvider.bottleRecords;
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Overview',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  BottleChart(bottleRecords: bottlesRecords),
                                  SizedBox(
                                    height: 80,
                                  ),
                                  BottleDataTable(
                                      bottleRecords: bottlesRecords),
                                ],
                              );
                            },
                          ),
                        if (selectedbutton == 2)
                          Consumer<SolidsProvider>(
                            builder: (context, solidProvider, child) {
                              List<SolidsData> solidsRecords =
                                  solidProvider.solidsRecords;

                              return Column(
                                children: [
                                  SolidsChart(solidsRecords: solidsRecords),
                                  SolidsDataTable(solidsRecords: solidsRecords),
                                ],
                              );
                            },
                          ),
                      ])
                ])))));
  }
}
