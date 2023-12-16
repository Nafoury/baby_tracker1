import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class SleepingView extends StatefulWidget {
  const SleepingView({super.key});

  @override
  State<SleepingView> createState() => _SleepingViewState();
}

class _SleepingViewState extends State<SleepingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SafeArea(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 30,
                      height: 30,
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
                  Text(
                    "Done",
                    style: TextStyle(color: Tcolor.black, fontSize: 14),
                  ),
                ],
              ),
            ]))));
  }
}
