import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
import 'package:baby_tracker/view/profiles/baby_Profile1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  late BabyProvider babyProvider;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(
                      "Add Child",
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
                        onPressed: () {},
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
                  onpressed: () {
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

                    babyProvider.addBabyData(
                      BabyInfo(
                        babyName: name.text,
                        babyHeight: double.tryParse(height.text),
                        babyWeight: double.tryParse(weight.text),
                        babyhead: double.tryParse(head.text),
                        gender: status,
                        dateOfBirth: startDate,
                      ),
                    );
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
