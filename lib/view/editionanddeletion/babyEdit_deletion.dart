import 'dart:io';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/view/login/complete_info.dart';
import 'package:baba_tracker/view/profiles/baby_Profile1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late DateTime startDate;
  late String status;
  late String name;
  late String weight;
  late String height;
  late String head;
  late TextEditingController nameController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController headController;

  late File? updatedFile = null;
  late File? myFile = null;

  late BabyProvider babyProvider;
  late BabyProvider babyProviderListener;

  @override
  void didChangeDependencies() {
    babyProvider = Provider.of<BabyProvider>(context, listen: false);
    babyProviderListener = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    startDate = widget.babyInfo.dateOfBirth!;
    status = widget.babyInfo.gender.toString();
    name = widget.babyInfo.babyName!;
    weight = widget.babyInfo.babyWeight?.toStringAsFixed(0) ?? '';
    height = widget.babyInfo.babyHeight?.toStringAsFixed(0) ?? '';
    head = widget.babyInfo.babyhead?.toStringAsFixed(0) ?? '';
    nameController = TextEditingController(text: name);
    weightController = TextEditingController(text: weight);
    heightController = TextEditingController(text: height);
    headController = TextEditingController(text: head);
    print(startDate);
    print(status);
    print(name);
    print(weight);
    print(head);
    print(height);
    print(widget.babyInfo.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [
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
                      child: widget.babyInfo.image != null &&
                              widget.babyInfo.image!.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    height: 130,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            XFile? xFile =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            setState(() {
                                              updatedFile = File(xFile!.path);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                "Upload Image From Gallery"),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            XFile? xFile =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.camera,
                                            );
                                            setState(() {
                                              updatedFile = File(xFile!.path);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text("Choose from Camera"),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            XFile? xFile =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.camera,
                                            );
                                            setState(() {
                                              updatedFile = File(xFile!.path);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              "Delete photo",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: widget.babyInfo.image!.isNotEmpty
                                    ? Image.network(
                                        "$linkImageFile/${widget.babyInfo.image}",
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      )
                                    : Image.asset(
                                        "assets/images/profile.png",
                                        fit: BoxFit.fitHeight,
                                        width: 20,
                                        height: 20,
                                      ),
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    height: 100,
                                    child: Column(children: [
                                      InkWell(
                                        onTap: () async {
                                          XFile? xFile =
                                              await ImagePicker().pickImage(
                                            source: ImageSource.gallery,
                                          );
                                          setState(() {
                                            updatedFile = File(xFile!.path);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child:
                                              Text("Upload Image From Gallery"),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          XFile? xFile =
                                              await ImagePicker().pickImage(
                                            source: ImageSource.camera,
                                          );
                                          setState(() {
                                            updatedFile = File(xFile!.path);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Choose from Camera"),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                              icon: Image.asset(
                                "assets/images/profile.png",
                                fit: BoxFit.fitHeight,
                                height: 20,
                                width: 20,
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

                                      List<BabyInfo> babies =
                                          babyProvider.babyRecords;
                                      if (babies.isEmpty) {
                                        // If the list becomes empty after deletion, navigate to the "Complete Info" page
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Completeinfo()),
                                        );
                                      } else {
                                        // Show SnackBar using a Builder widget to ensure a valid context

                                        Navigator.of(context).pop();
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
                        if (updatedFile == null) {
                          BabyInfo babyInfo = BabyInfo(
                            babyName: nameController.text,
                            gender: status,
                            dateOfBirth: startDate,
                            babyHeight: double.tryParse(heightController.text),
                            babyWeight: double.tryParse(weightController.text),
                            babyhead: double.tryParse(headController.text),
                            infoId: widget.babyInfo.infoId!,
                          );

                          await babyProvider.editBabyRecord(babyInfo, myFile);
                        } else {
                          BabyInfo babyInfo = BabyInfo(
                            babyName: nameController.text,
                            gender: status,
                            dateOfBirth: startDate,
                            babyHeight: double.tryParse(heightController.text),
                            babyWeight: double.tryParse(weightController.text),
                            babyhead: double.tryParse(headController.text),
                            infoId: widget.babyInfo.infoId!,
                          );

                          await babyProvider.editBabyRecord(
                              babyInfo, updatedFile);
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
              ]))),
    );
  }
}
