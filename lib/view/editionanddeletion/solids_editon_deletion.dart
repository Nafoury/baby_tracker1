import 'dart:ffi';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';

import 'package:baba_tracker/models/solidsData.dart';

import 'package:baba_tracker/provider/solids_provider.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class SolidsEdit extends StatefulWidget {
  final SolidsData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  SolidsEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _SolidsEditState createState() => _SolidsEditState();
}

class _SolidsEditState extends State<SolidsEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late int fruits;
  late int veg;
  late int meat;
  late int grain;
  late int dairy;
  late String note;
  late TextEditingController noteController;
  late TextEditingController fruitController;
  late TextEditingController grainController;
  late TextEditingController proteinController;
  late TextEditingController dairyController;
  late TextEditingController vegController;
  late SolidsProvider solidsProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    fruits = widget.entryData.fruits ?? 0;
    veg = widget.entryData.veg ?? 0;
    meat = widget.entryData.protein ?? 0;
    grain = widget.entryData.grains ?? 0;
    dairy = widget.entryData.dairy ?? 0;
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);
    fruitController = TextEditingController(text: fruits.toString());
    vegController = TextEditingController(text: veg.toString());
    proteinController = TextEditingController(text: meat.toString());
    grainController = TextEditingController(text: grain.toString());
    dairyController = TextEditingController(text: dairy.toString());
  }

  @override
  void didChangeDependencies() {
    solidsProvider = Provider.of<SolidsProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateSolidsData(DateTime startDate) async {
    List<SolidsData> existingData = await solidsProvider.getSolidsRecords();
    bool duplicateExists = existingData.any((solids) =>
        solids.date!.year == startDate.year &&
        solids.date!.month == startDate.month &&
        solids.date!.day == startDate.day &&
        solids.date!.hour == startDate.hour &&
        solids.date!.minute == startDate.minute);
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
                    "Edit Solids",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (widget.entryData.solidId != null) {
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
                                    solidsProvider.deleteSolidsRecord(
                                        widget.entryData.solidId!);
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
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const Column(
                        children: [
                          SizedBox(height: 25),
                          Divider(
                            color: Colors.grey,
                            height: 1,
                          ),
                        ],
                      );
                    },
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      switch (index) {
                        case 0:
                          return GestureDetector(
                              onTap: () {
                                _showStartDatePicker(context,
                                    startDate!); // Show date picker for start date
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(" Date & Time ",
                                      style: TextStyle(
                                          color: Tcolor.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    DateFormat('dd MMM yyyy  HH:mm')
                                        .format(startDate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ));

                        case 1:
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.pink
                                      .shade100, // Customize the color as needed
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Fruits ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                width: 275, // Adjust the width as needed
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: fruitController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      fruitController.text =
                                          value; // Assign value to the text property
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "0g",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        case 2:
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green
                                      .shade200, // Customize the color as needed
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Vegetables ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                width: 233, // Adjust the width as needed
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: vegController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      vegController.text =
                                          value; // Assign value to the text property
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "0g",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        case 3:
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.brown
                                      .shade200, // Customize the color as needed
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text("Meat & Protein ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                width: 205, // Adjust the width as needed
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: proteinController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      proteinController.text =
                                          value; // Assign value to the text property
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "0g",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        case 4:
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                                      .shade100, // Customize the color as needed
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Grains",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                width: 270, // Adjust the width as needed
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: grainController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      grainController.text = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "0g",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        case 5:
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                                      .shade500, // Customize the color as needed
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Dairy",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 14,
                                  )),
                              SizedBox(
                                width: 280, // Adjust the width as needed
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  controller: dairyController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {},
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "0g",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        case 6:
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: TextField(
                                controller: noteController,
                                onChanged: (newNote) {
                                  setState(() {
                                    note = newNote;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "note",
                                  // Set your desired hint text
                                ),
                              ))
                            ],
                          );
                        default:
                          return SizedBox();
                      }
                    }),
              ),
              SizedBox(height: 60),
              RoundButton(
                  onpressed: () async {
                    if (widget.entryData.solidId != null) {
                      bool duplicateExists =
                          await _checkDuplicateSolidsData(startDate!);
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
                              content: Text(
                                  "Solids data of the same amount, date, and hour already exists."),
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
                        solidsProvider.editSolidsRecord(SolidsData(
                            date: startDate,
                            fruits: int.parse(fruitController
                                .text), // Retrieve value from controller
                            grains: int.parse(grainController
                                .text), // Retrieve value from controller
                            veg: int.parse(vegController
                                .text), // Retrieve value from controller
                            protein: int.parse(proteinController
                                .text), // Retrieve value from controller
                            dairy: int.parse(dairyController.text), //
                            note: note,
                            solidId: widget.entryData.solidId));

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
                                  Text("Solids Data was successfully updated."),
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
                  title: "Save changes"),
            ],
          ),
        ),
      ),
    );
  }

  void _showStartDatePicker(BuildContext context, DateTime initialDateTime) {
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDateTime,
            minimumDate: minimumDateTime,
            maximumDate: maximumDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              print('New DateTime: $newDateTime');
              setState(() {
                startDate = newDateTime;
                print('Updated startDate: $startDate');
                widget.onDateStratTimeChanged?.call(startDate!);
              });
            },
          ),
        );
      },
    );
  }
}
