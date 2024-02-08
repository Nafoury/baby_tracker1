import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/homecontroller.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SleepingView extends StatefulWidget {
  const SleepingView({super.key});

  @override
  State<SleepingView> createState() => _SleepingViewState();
}

class _SleepingViewState extends State<SleepingView> {
  int selectButton = 0;
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  SleepController sleepController = SleepController();

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
                  const SizedBox(width: 85),
                  Text(
                    "Sleeping",
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
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                          alignment: selectButton == 0
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
                                      selectButton = 0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Sleeping",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: selectButton == 0
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
                                      selectButton = 1;
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
                                          color: selectButton == 1
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
                if (selectButton == 0)
                  Column(
                    children: [
                      TrackingWidget(
                        trackingType: TrackingType.Sleeping,
                        startDate: startDate,
                        endDate: endDate,
                        onDateTimeChanged:
                            (DateTime newStartDate, DateTime newEndDate) {
                          setState(() {
                            startDate = newStartDate;
                            endDate = newEndDate;
                          });
                        },
                      ),
                      SizedBox(height: 300),
                      RoundButton(
                        onpressed: () async {
                          var sleepDataProvider =
                              Provider.of<SleepDataProvider>(context,
                                  listen: false);
                          SleepData sleepData = SleepData(
                            startDate: startDate,
                            endDate: endDate,
                            id: sharedPref.getString("id") ?? "",
                          );
                          bool isSaved = await sleepController.saveSleepData(
                              sleepData: sleepData);
                          if (!isSaved) {
                            // Show a success message or handle as needed
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Invalid Duration'),
                                  content: Text("The duration can't be zero"),
                                );
                              },
                            );
                          } else {
                            sleepDataProvider.addOrUpdateSleepRecord(sleepData);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Sucess'),
                                  content: Text("The duration is saved"),
                                );
                              },
                            );
                          }
                          setState(() {
                            startDate = DateTime
                                .now(); // Replace with your initial/default date values
                            endDate = DateTime
                                .now(); // Replace with your initial/default date values
                          });
                        },
                        title: "Save sleep",
                      )
                    ],
                  ),
                //summay UI

                if (selectButton == 1)
                  Consumer<SleepDataProvider>(
                    builder: (context, sleepDataProvider, _) {
                      List<SleepData> sleepRecords =
                          sleepDataProvider.sleepRecords;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text('Date'),
                              numeric: false,
                            ),
                            DataColumn(
                                label: Text('Total Duration'), numeric: true),
                          ],
                          rows: sleepRecords.map((sleepData) {
                            Duration duration = sleepData.endDate
                                .difference(sleepData.startDate);
                            String totalDuration =
                                '${duration.inHours} hours ${duration.inMinutes.remainder(60)} minutes';
                            String formattedDate = DateFormat('dd MMM yyyy  ')
                                .format(sleepData
                                    .startDate); // Adjust date format as needed

                            return DataRow(cells: [
                              DataCell(Text(formattedDate)),
                              DataCell(Text(totalDuration)),
                            ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
              ])
            ]))));
  }
}
