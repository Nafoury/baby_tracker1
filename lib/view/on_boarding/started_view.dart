import 'package:baba_tracker/common_widgets/on_boarding_page.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/view/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';

class Startview extends StatefulWidget {
  const Startview({super.key});

  @override
  State<Startview> createState() => _StartviewState();
}

class _StartviewState extends State<Startview> {
  bool isChangedcolor = true;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Container(
          width: media.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: Tcolor.primaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "Baby",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RoundButton(
                  title: "Get Started",
                  type: isChangedcolor
                      ? RoundButtonType.textGradient
                      : RoundButtonType.bgGradiant,
                  onpressed: () async {
                    Get.to(OnBoradingView1());
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          )),
    );
  }
}
