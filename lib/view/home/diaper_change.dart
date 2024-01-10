import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:get/get.dart';

class DiaperChange extends StatefulWidget {
  const DiaperChange({super.key});

  @override
  State<DiaperChange> createState() => _DiaperChangeState();
}

class _DiaperChangeState extends State<DiaperChange> {
  int selectedbutton = 0;
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(hours: 8));
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(width: 85),
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
                              gradient: LinearGradient(colors: Tcolor.primaryG),
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
                                      "Diaper",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: selectedbutton == 0
                                              ? Tcolor.white
                                              : Tcolor.gray,
                                          fontSize: 16,
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
                                      "Summary",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: selectedbutton == 1
                                              ? Tcolor.white
                                              : Tcolor.gray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
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
                  Column(
                    children: [
                      TrackingWidget(
                        trackingType: TrackingType.Diaper,
                        summaryOnly: false,
                        startDate: startDate ??
                            DateTime.now(), // Ensure startDate is not null
                        onDateTimeChanged:
                            (DateTime newStartDate, DateTime newEndDate) {
                          setState(() {
                            startDate = newStartDate;
                          });
                        },
                      ),
                      SizedBox(
                          height:
                              300), // Call the method/widget to display detailed tracking info
                      RoundButton(onpressed: () {}, title: "Save change")
                    ],
                  ),
                if (selectedbutton == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),

                //sleeping UI
              ],
            )
          ]))),
    );
  }
}
