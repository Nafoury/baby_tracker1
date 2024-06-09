import 'dart:io';

import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/view/profiles/baby_Profile1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BabyProfile extends StatefulWidget {
  const BabyProfile({super.key});

  @override
  State<BabyProfile> createState() => _BabyProfileState();
}

class _BabyProfileState extends State<BabyProfile> {
  DateTime? startDate = DateTime.now();
  final name = TextEditingController();
  final weight = TextEditingController();
  final head = TextEditingController();
  final height = TextEditingController();
  String status = '';
  late File? myfile = null;
  late BabyProvider babyProvider;
  late File? imageFile = null;

  @override
  void didChangeDependencies() {
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    // Reset the selectedDate when the page is initialized
    startDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      "Add Child",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
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
                      'child',
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
                                      myfile = File(xFile!.path);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Upload Image From Gallery"),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    XFile? xFile =
                                        await ImagePicker().pickImage(
                                      source: ImageSource.camera,
                                    );
                                    setState(() {
                                      myfile = File(xFile!.path);
                                    });
                                    Navigator.pop(context);
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
                        ),
                      ),
                    ),
                  ],
                ),
                BabyProfile1(
                  selectedDate: startDate,
                  nameController: name,
                  status: status,
                  weightController1: weight,
                  headController: head,
                  heightController: height,
                  onStatusChanged: (String? newstatus) {
                    setState(() {
                      status = newstatus ?? '';
                    });
                  },
                  onStartDateChanged: (DateTime newStartDate) {
                    setState(() {
                      startDate = newStartDate;
                      print(startDate);
                    });
                  },
                ),
                RoundButton(
                  onpressed: () async {
                    if (name.text.isEmpty) {
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
                              "Baby name can't be empty",
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
                    if (startDate == null) {
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
                              "Date of birth can't be empty",
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
                            title: Image.asset(
                              "assets/images/warning.png",
                              height: 60,
                              width: 60,
                            ),
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

                    if (myfile == null) {
                      BabyInfo babyInfo = BabyInfo(
                        babyName: name.text,
                        babyHeight: double.tryParse(height.text),
                        babyWeight: double.tryParse(weight.text),
                        babyhead: double.tryParse(head.text),
                        gender: status,
                        dateOfBirth: startDate,
                      );

                      await babyProvider.addBabyData(babyInfo, imageFile);
                    } else {
                      BabyInfo babyInfo = BabyInfo(
                        babyName: name.text,
                        babyHeight: double.tryParse(height.text),
                        babyWeight: double.tryParse(weight.text),
                        babyhead: double.tryParse(head.text),
                        gender: status,
                        dateOfBirth: startDate,
                      );

                      await babyProvider.addBabyData(babyInfo, myfile);
                    }

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
                            'Baby was successfully added',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                          actions: <Widget>[
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
                    setState(() {
                      name.clear();
                      startDate = DateTime.now();
                      status = '';
                      height.clear();
                      head.clear();
                      weight.clear();
                    });
                  },
                  title: 'Add',
                ),
              ],
            ),
          ),
        ));
  }
}
