import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/common_widgets/babybottle.dart';

class FeedingView extends StatefulWidget {
  const FeedingView({Key? key});

  @override
  State<FeedingView> createState() => _FeedingViewState();
}

class _FeedingViewState extends State<FeedingView> {
  int selectedbutton = 0; // Assuming you have a selectButton variable
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(hours: 8));
  double bottlePositionX = 100.0;
  double bottlePositionY = 100.0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
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
                                : Alignment.centerRight,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: (media.width * 0.5) - 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient:
                                    LinearGradient(colors: Tcolor.primaryG),
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
                                        borderRadius: BorderRadius.circular(30),
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
                                        borderRadius: BorderRadius.circular(30),
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
                                        borderRadius: BorderRadius.circular(30),
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
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedbutton = 3;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "Summary",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: selectedbutton == 3
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
                    Column(children: [
                      TrackingWidget(
                        trackingType: TrackingType.Feeding,
                        startDate: startDate,
                        endDate: endDate,
                        summaryOnly: false,
                        onDateTimeChanged:
                            (DateTime newStartDate, DateTime newEndDate) {
                          setState(() {
                            startDate = newStartDate;
                            endDate = newEndDate;
                          });
                        },
                      ),
                    ]),
                  if (selectedbutton == 1) BabyBottleSelector()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
