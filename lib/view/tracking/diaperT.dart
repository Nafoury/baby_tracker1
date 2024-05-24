import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/diapercontroller.dart';

import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/diaper_provider.dart';
import 'package:baba_tracker/view/charts/solidschart.dart';

import 'package:baba_tracker/view/home/diaper_change.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:baba_tracker/view/charts/diaperchart.dart';

import 'package:provider/provider.dart';

class DiaperTracking extends StatefulWidget {
  const DiaperTracking({super.key});

  @override
  State<DiaperTracking> createState() => _SleepingViewState();
}

class _SleepingViewState extends State<DiaperTracking> {
  int selectButton = 0;
  late BabyProvider babyProvider = BabyProvider();
  DiaperController diaperController = DiaperController();

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
                    const SizedBox(width: 90),
                    Text(
                      "Diaper",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Overview',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<DiaperProvider>(
                  builder: (context, diaperProvider, child) {
                    List<DiaperData> diaperRecords =
                        diaperProvider.diaperRecords;

                    return AspectRatio(
                      aspectRatio: 1,
                      child: DiaperChart(diaperRecords: diaperRecords),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiaperChange()),
                      );
                    },
                    title: "Add Diaper")
              ])))),
    );
  }
}
