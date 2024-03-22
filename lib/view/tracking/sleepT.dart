import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/sleepcontroller.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:baby_tracker/view/charts/sleepchart.dart';
import 'package:baby_tracker/view/home/sleeping_view.dart';
import 'package:baby_tracker/view/summary/sleepDataTable.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SleepTracking extends StatelessWidget {
  const SleepTracking({super.key});

  @override
  Widget build(BuildContext context) {
    SleepController sleepController = SleepController();
    final List<List<int>> dummySleepData =
        List.generate(7, (_) => List.filled(24, 0));
    // Generate a 7x24 grid of zeros representing no sleep hours for each hour of the day for 7 days
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    SizedBox(
                      width: 85,
                    ),
                    Text(
                      "Sleeping",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
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
