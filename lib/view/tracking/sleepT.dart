import 'package:baby_tracker/controller/sleepcontroller.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/view/charts/sleepchart.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';

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
                FutureBuilder(
                  future: sleepController.retrievesleepData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Loading.."));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final List<SleepData> sleepRecords = snapshot.data!;
                      final List<Map<String, dynamic>> sleepData =
                          sleepRecords.map((data) => data.toJson()).toList();
                      return AspectRatio(
                          aspectRatio: 3.7,
                          child: SleepHeatmap(sleepData: sleepData));
                    } else {
                      return Center(child: Text('No sleep data available.'));
                    }
                  },
                ),
              ])),
            )));
  }
}
