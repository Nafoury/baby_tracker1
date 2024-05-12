import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'package:baby_tracker/view/profiles/baby_Profile1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class BabyProfileEditAndDeletion extends StatefulWidget {
  final BabyInfo babyInfo;
  const BabyProfileEditAndDeletion({super.key, required this.babyInfo});

  @override
  State<BabyProfileEditAndDeletion> createState() =>
      _BabyProfileEditAndDeletionState();
}

class _BabyProfileEditAndDeletionState
    extends State<BabyProfileEditAndDeletion> {
  DateTime? startDate = DateTime.now();
  late TextEditingController dateController;
  late String status;
  late String name;
  late TextEditingController nameController;
  late String weight;
  late TextEditingController weightController;
  late String height;
  late TextEditingController heightController;
  late String head;
  late TextEditingController headController;
  late BabyProvider babyProvider;

  @override
  void didChangeDependencies() {
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    startDate = widget.babyInfo.dateOfBirth;
    dateController = TextEditingController(
        text: startDate != null ? startDate!.toString() : '');
    name = widget.babyInfo.babyName!;
    nameController = TextEditingController(text: name);
    weight = widget.babyInfo.babyWeight?.toStringAsFixed(0) ?? '';
    weightController = TextEditingController(text: weight);
    height = widget.babyInfo.babyWeight?.toStringAsFixed(0) ?? '';
    heightController = TextEditingController(text: height);
    head = widget.babyInfo.babyhead?.toStringAsFixed(0) ?? '';
    headController = TextEditingController(text: head);
    status = widget.babyInfo.gender.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      "Edit Child",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 2,
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$name",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      minRadius: 25,
                      maxRadius: 25,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/images/profile.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      if (widget.babyInfo.infoId != null) {
                        await babyProvider
                            .makeBabyActive(widget.babyInfo.infoId!);
                      }
                    },
                    child: Text('Make Active ')),
                BabyProfile1(
                  nameController: nameController,
                  selectedValue: status.toString(),
                  weightController1: weightController,
                  heightController: heightController,
                  headController: headController,
                  selectedDate: startDate,
                  onStartDateChanged: (DateTime newStartDate) {
                    setState(() {
                      startDate = newStartDate;
                      print(startDate);
                    });
                  },
                  onStatusChanged: (String? value) {
                    setState(() {
                      status = value.toString();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (widget.babyInfo.infoId != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                    "Are you sure you want to delete the baby"),
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
                                      await babyProvider.deleteBabyRecord(
                                          widget.babyInfo.infoId!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Durations.medium1,
                                          backgroundColor:
                                              Tcolor.gray.withOpacity(0.4),
                                          content: Text(
                                              "Baby was successfully deleted."),
                                        ),
                                      );
                                      List<BabyInfo> babies =
                                          babyProvider.babyRecords;
                                      if (babies.length == 0) {
                                        // If the list becomes empty after deletion, navigate to the "Complete Info" page
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Completeinfo()),
                                        );
                                      }
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
                        'Delete a child',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade200,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (nameController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  "name can't be empty",
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
                          return;
                        }
                        if (status.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset("assets/images/warning.png",
                                    height: 60, width: 60),
                                content: Text(
                                  "Gender can't be empty",
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
                          return;
                        }

                        babyProvider.editBabyRecord(BabyInfo(
                          babyName: nameController.text,
                          gender: status,
                          dateOfBirth: startDate,
                          babyHeight: double.tryParse(heightController.text),
                          babyWeight: double.tryParse(weightController.text),
                          babyhead: double.tryParse(headController.text),
                          infoId: widget.babyInfo.infoId!,
                        ));
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
                                  Text("Baby Data was successfully updated."),
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
                      },
                      child: Text(
                        'Edit a child',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue.shade300,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
