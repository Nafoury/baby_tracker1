import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/weightBalance.dart';
import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:baba_tracker/provider/babyHeadProvider.dart';
import 'package:baba_tracker/provider/babyHeightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class BabyHeightEdit extends StatefulWidget {
  final HeightMeasureData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  BabyHeightEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _BabyHeightEditState createState() => _BabyHeightEditState();
}

class _BabyHeightEditState extends State<BabyHeightEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late double mlvalue;
  late HeightMeasureProvider heightMeasureProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    mlvalue = widget.entryData.measure!.toDouble();
  }

  Future<bool> _checkDuplicateHeightData(DateTime startDate) async {
    List<HeightMeasureData> existingData =
        await heightMeasureProvider.getMeasureRecords();
    bool duplicateExists = existingData.any((headcirc) =>
        headcirc.measure == mlvalue &&
        headcirc.date!.year == startDate.year &&
        headcirc.date!.month == startDate.month &&
        headcirc.date!.day == startDate.day);
    return duplicateExists;
  }

  @override
  void didChangeDependencies() {
    heightMeasureProvider =
        Provider.of<HeightMeasureProvider>(context, listen: false);
    super.didChangeDependencies();
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
                      "Edit Measure",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.heightId != null) {
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
                                      await heightMeasureProvider
                                          .deleteHeightRecord(
                                              widget.entryData.heightId!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Durations.medium1,
                                          backgroundColor:
                                              Tcolor.gray.withOpacity(0.4),
                                          content: Text(
                                              "Record was successfully deleted."),
                                        ),
                                      );
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
                    initialWeight: mlvalue,
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
                        mlvalue = value;
                      });
                    }),
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () async {
                      if (widget.entryData.heightId != null) {
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
                                content: Text("Measure data can't be zero"),
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
                            await _checkDuplicateHeightData(startDate!);
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
                                    Text("You're already added measure today."),
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
                          heightMeasureProvider.editHeightRecord(
                              HeightMeasureData(
                                  date: startDate,
                                  measure: mlvalue,
                                  heightId: widget.entryData.heightId));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/change.png",
                                  height: 60,
                                  width: 60,
                                ),
                                content: Text(
                                    "Measure Data was successfully updated."),
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
                      Navigator.pop(context);
                    },
                    title: "Save changes")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
