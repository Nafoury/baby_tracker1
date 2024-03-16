import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/view/charts/sleepchart.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

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
              BalanceWeight(),
              SizedBox(
                height: 20,
              ),
              RoundButton(onpressed: () {}, title: "Save Weight")
            ])))));
  }
}
