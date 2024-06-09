import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/sleepcontroller.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/sleep_provider.dart';
import 'package:baba_tracker/view/charts/sleepchart.dart';
import 'package:baba_tracker/view/home/sleeping_view.dart';
import 'package:baba_tracker/view/summary/sleepDataTable.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SleepTracking extends StatelessWidget {
  const SleepTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "Sleeping",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Consumer<BabyProvider>(
                      builder: (context, babyProvider, child) {
                        return Text(
                          " ${babyProvider.activeBaby?.babyName ?? 'Baby'}",
                          style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<SleepProvider>(
                  builder: (context, sleepProvider, child) {
                    List<SleepData> sleepRecords = sleepProvider.sleepRecords;
                    return Column(
                      children: [
                        SleepHeatmap(sleepData: sleepRecords),
                        RoundButton(
                            onpressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SleepingView(),
                                ),
                              );
                            },
                            title: "Add sleep"),
                        SleepDataTable(sleepRecords: sleepRecords),
                      ],
                    );
                  },
                ),
              ])),
            )));
  }
}
