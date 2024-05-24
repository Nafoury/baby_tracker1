import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/view/charts/tempChart.dart';
import 'package:baba_tracker/view/subTrackingPages/addTemp.dart';
import 'package:baba_tracker/view/subTrackingPages/addVaccine.dart';
import 'package:baba_tracker/view/subTrackingPages/addmed.dart';
import 'package:baba_tracker/view/summary/medicationsTable.dart';
import 'package:baba_tracker/view/summary/temDataTable.dart';
import 'package:baba_tracker/view/summary/vaccineTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HealthTracking extends StatefulWidget {
  const HealthTracking({Key? key});

  @override
  State<HealthTracking> createState() => _HealthTracking();
}

class _HealthTracking extends State<HealthTracking> {
  int selectedbutton = 0;
  DateTime dateTime = DateTime.now();
  DateTime startDate = DateTime.now();
  final _note = TextEditingController();
  final _note1 = TextEditingController();
  final _note2 = TextEditingController();
  String status = '';
  String status1 = '';
  final ValueNotifier<double> temperature = ValueNotifier(0.5);
  late TempProvider tempProvider;
  late List<TempData> tempRecords = [];

  @override
  void didChangeDependencies() {
    tempProvider = Provider.of<TempProvider>(context, listen: false);
    super.didChangeDependencies();
    fetchTempRecords(tempProvider);
  }

  Future<void> fetchTempRecords(TempProvider tempProvider) async {
    try {
      List<TempData> records = await tempProvider.getTempRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        tempRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

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
                      SizedBox(width: 85),
                      Text(
                        "Health",
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
                                      : selectedbutton == 1
                                          ? Alignment.center
                                          : (selectedbutton == 2
                                              ? Alignment.centerRight
                                              : Alignment.centerRight),
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    width: (media.width * 0.4) - 30,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: Tcolor.primaryG),
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
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              "Temperture",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: selectedbutton == 0
                                                      ? Tcolor.white
                                                      : Tcolor.gray,
                                                  fontSize: 13,
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
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              "Vaccines",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: selectedbutton == 1
                                                      ? Tcolor.white
                                                      : Tcolor.gray,
                                                  fontSize: 13,
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
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              "Medications",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: selectedbutton == 2
                                                      ? Tcolor.white
                                                      : Tcolor.gray,
                                                  fontSize: 13,
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
                          height: 10,
                        ),
                        if (selectedbutton == 0)
                          Consumer<TempProvider>(
                            builder: (context, tempProvider, child) {
                              return Column(children: [
                                TempChart(
                                  tempRecords: tempRecords,
                                ),
                                RoundButton(
                                    onpressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTemp()),
                                      );
                                    },
                                    title: "Add Temperture"),
                                TempDataTable(tempRecords: tempRecords),
                              ]);
                            },
                          ),
                        if (selectedbutton == 1)
                          Column(children: [
                            VaccineRecordsTable(),
                            SizedBox(
                              height: 30,
                            ),
                            RoundButton(
                                onpressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddVaccine()),
                                  );
                                },
                                title: "Add Vaccine"),
                          ]),
                        if (selectedbutton == 2)
                          Column(
                            children: [
                              MediciationRecordsTable(),
                              SizedBox(
                                height: 60,
                              ),
                              RoundButton(
                                  onpressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddMed()),
                                    );
                                  },
                                  title: "Add drug"),
                            ],
                          )
                      ])
                ])))));
  }
}
