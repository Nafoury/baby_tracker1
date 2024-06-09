import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/weightBalance.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/models/momweightData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/momWeightProvider.dart';
import 'package:baba_tracker/provider/weightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class BabyWeightEdit extends StatefulWidget {
  final WeightData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  BabyWeightEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _BabyWeightEditState createState() => _BabyWeightEditState();
}

class _BabyWeightEditState extends State<BabyWeightEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late double mlvalue;
  late WeightProvider weightProvider;
  late BabyProvider babyProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    mlvalue = widget.entryData.weight!.toDouble();
  }

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: true);
    babyProvider = Provider.of<BabyProvider>(context, listen: false);

    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateWeightData(DateTime startDate) async {
    List<WeightData> existingData = await weightProvider.getWeightRecords();
    bool duplicateExists = existingData.any((weight) =>
        weight.weight == mlvalue &&
        weight.date!.year == startDate.year &&
        weight.date!.month == startDate.month &&
        weight.date!.day == startDate.day);
    return duplicateExists;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
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
                      "Edit Weight",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (widget.entryData.weightId != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                    "Are you sure you want to delete this record?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await weightProvider.deleteWeigthRecord(
                                          widget.entryData.weightId!);

                                      Navigator.of(context).pop();

                                      // Go back to the previous page
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red.shade200),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                BalanceWeight(
                  userBirthDate: babyProvider.activeBaby!.dateOfBirth!,
                  max: 200,
                  min: 0,
                  initialWeight: mlvalue, // Pass the initial weight
                  onWeightChanged: (double value) {
                    setState(() {
                      mlvalue = value;
                    });
                  },
                  startDate: startDate,
                  onStartDateChanged: (DateTime newStartDate) {
                    setState(() {
                      startDate = newStartDate;
                    });
                  },
                ),
                SizedBox(height: 20),
                RoundButton(
                  onpressed: () async {
                    if (widget.entryData.weightId != null) {
                      if (mlvalue.isEqual(0)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/warning.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text("weight can't be empty"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      bool duplicateExists =
                          await _checkDuplicateWeightData(startDate!);
                      if (duplicateExists) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/warning.png",
                                height: 60,
                                width: 60,
                              ),
                              content:
                                  Text("You're already added weight today"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      } else {
                        await weightProvider.editWeightRecord(WeightData(
                            date: startDate,
                            weight: mlvalue,
                            weightId: widget.entryData.weightId!));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/change.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text("Weight was successfully updated."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  title: "Save changes",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
