import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/controller/momController.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/provider/momWeightProvider.dart';

import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
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
                  onpressed: () {
                    momWeightProvider.addWeightData(MomData(
                        date: startDate,
                        weight: mlValue,
                        babyId: sharedPref.getString("info_id")));
                  },
                  title: "Save Weight")
            ])))));
  }
}
