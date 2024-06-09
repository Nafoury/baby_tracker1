import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/healthActivites.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/teethController.dart';
import 'package:baba_tracker/models/teethModel.dart';

import 'package:baba_tracker/view/more/toothPgae.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TeethEdit extends StatefulWidget {
  final TeethData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  TeethEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _TeethEditState createState() => _TeethEditState();
}

class _TeethEditState extends State<TeethEdit> {
  Crud crud = Crud();
  late DateTime? date;
  late String choice;
  late String choice1;
  TeethController teethController = new TeethController();

  @override
  void initState() {
    super.initState();
    date = widget.entryData.date;
    choice = widget.entryData.upper!;
    choice1 = widget.entryData.lower!;
  }

  Future<bool> _checkDuplicateTeethData(DateTime startDate) async {
    List<TeethData> existingData = await teethController.retrieveTeethData();
    bool duplicateExists = existingData.any((teeth) =>
        teeth.date! == startDate &&
        teeth.upper! == choice &&
        teeth.lower! == choice1);
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
                    "Edit Teeth",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.entryData.toothId != null) {
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
                                    await teethController
                                        .deleteTeeth(widget.entryData.toothId!);
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
              Padding(
                padding: EdgeInsets.all(10),
                child: TeethDropDown(
                  startDate: date,
                  choice1: choice1,
                  choice: choice,
                  onDateStratTimeChanged: (DateTime newStartDate) {
                    setState(() {
                      date = newStartDate;
                    });
                  },
                  onStatusChanged: (String value1) {
                    setState(() {
                      choice = value1;
                    });
                  },
                  onChoiceChanged: (String value) {
                    setState(() {
                      choice1 = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 205),
              RoundButton(
                  onpressed: () async {
                    if (choice.isNotEmpty || choice1.isNotEmpty) {
                      bool existing = await _checkDuplicateTeethData(date!);
                      if (existing) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset("assets/images/warning.png",
                                  height: 60, width: 60),
                              content: Text(
                                "Teeth data already exists.",
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                              actions: <Widget>[
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
                      } else {
                        teethController.editTeeth(TeethData(
                            date: date,
                            upper: choice,
                            lower: choice1,
                            toothId: widget.entryData.toothId));

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/check.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text(
                                'Data was successfully updated',
                                style: TextStyle(fontStyle: FontStyle.normal),
                              ),
                              actions: <Widget>[
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
                        setState(() {
                          choice = '';
                          choice1 = '';
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Image.asset("assets/images/warning.png",
                                height: 60, width: 60),
                            content: Text(
                              "Fields can't be empty",
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            actions: <Widget>[
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
