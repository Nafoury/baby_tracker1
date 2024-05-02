import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/provider/momWeightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

import 'package:provider/provider.dart';

class MomWeightEdit extends StatefulWidget {
  final MomData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  MomWeightEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _MomWeightEditState createState() => _MomWeightEditState();
}

class _MomWeightEditState extends State<MomWeightEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late double mlvalue;
  late MomWeightProvider momWeightProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    mlvalue = widget.entryData.weight!.toDouble();
    print({'records value $mlvalue'});
  }

  @override
  void didChangeDependencies() {
    momWeightProvider = Provider.of<MomWeightProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateWeightData(DateTime date) async {
    List<MomData> existingData = await momWeightProvider.getWeightRecords();
    bool duplicateExists = existingData.any((weight) =>
        weight.weight == mlvalue &&
        weight.date!.year == date.year &&
        weight.date!.month == date.month &&
        weight.date!.day == date.day);
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
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // Get.offAllNamed("/mainTab");
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
                      if (widget.entryData.momId != null) {
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
                                    await momWeightProvider.deleteWeigthRecord(
                                        widget.entryData.momId!);
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                    if (widget.entryData.momId != null) {
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
                              content: Text("Weight can't be zero"),
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
                        momWeightProvider.editWeightRecord(MomData(
                            date: startDate,
                            weight: mlvalue,
                            momId: widget.entryData.momId!));
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Image.asset(
                              "assets/images/change.png",
                              height: 60,
                              width: 60,
                            ),
                            content:
                                Text("Weight Data was successfully updated."),
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
                  },
                  title: "Save changes"),
            ],
          ),
        ),
      ),
    );
  }
}
