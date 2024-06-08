import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
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
  late BabyProvider babyProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TempProvider>(context, listen: false).getTempRecords();
    Provider.of<MedicationsProvider>(context, listen: false)
        .getMedicationRecords();
    Provider.of<VaccineProvider>(context, listen: false).getVaccineRecords();
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      "Health",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      babyProvider.activeBaby!.babyName!,
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                                  : Alignment.centerRight,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width: (media.width * 0.4) - 30,
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
                                      "Temperture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: selectedbutton == 0
                                            ? Tcolor.white
                                            : Tcolor.gray,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                      "Vaccines",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: selectedbutton == 1
                                            ? Tcolor.white
                                            : Tcolor.gray,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                      "Medications",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: selectedbutton == 2
                                            ? Tcolor.white
                                            : Tcolor.gray,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedbutton == 0)
                  Consumer<TempProvider>(
                    builder: (context, tempProvider, child) {
                      return Column(
                        children: [
                          TempChart(
                            tempRecords: tempProvider.tempRecords,
                          ),
                          RoundButton(
                            onpressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTemp(),
                                ),
                              );
                            },
                            title: "Add Temperture",
                          ),
                          TempDataTable(
                            tempRecords: tempProvider.tempRecords,
                          ),
                        ],
                      );
                    },
                  ),
                if (selectedbutton == 1)
                  Consumer<VaccineProvider>(
                    builder: (context, vaccineProvider, child) {
                      return Column(
                        children: [
                          VaccineRecordsTable(
                            vaccineRecords: vaccineProvider.vaccineRecords,
                          ),
                          SizedBox(height: 30),
                          RoundButton(
                            onpressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddVaccine(),
                                ),
                              );
                            },
                            title: "Add Vaccine",
                          ),
                        ],
                      );
                    },
                  ),
                if (selectedbutton == 2)
                  Consumer<MedicationsProvider>(
                      builder: (context, medicationProvider, child) {
                    return Column(
                      children: [
                        MediciationRecordsTable(
                            medicationRecords:
                                medicationProvider.medicationRecords),
                        SizedBox(height: 60),
                        RoundButton(
                          onpressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMed(),
                              ),
                            );
                          },
                          title: "Add drug",
                        ),
                      ],
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
