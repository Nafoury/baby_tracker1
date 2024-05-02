import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/babyWeight.dart';
import 'package:baby_tracker/provider/weightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BabyWeightPage extends StatefulWidget {
  const BabyWeightPage({super.key});

  @override
  State<BabyWeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<BabyWeightPage> {
  double mlValue = 0.0;

  DateTime startDate = DateTime.now();
  late WeightProvider weightProvider;

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: true);
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
                    weightProvider.addWeightData(WeightData(
                        date: startDate,
                        weight: mlValue,
                        babyId: sharedPref.getString("info_id")));
                  },
                  title: "Save Weight")
            ])))));
  }
}
