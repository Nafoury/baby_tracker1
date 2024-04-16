import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
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
    babyProvider = Provider.of<BabyProvider>(context, listen: false);
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
                      "Child",
                      style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
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
                    onPressed: () {
                      if (widget.babyInfo.infoId != null) {
                        babyProvider.makeBabyActive(widget.babyInfo.infoId!);
                      }
                    },
                    child: Text('Make Active ')),
                BabyProfile1(
                  nameController: nameController,
                  selectedValue: status,
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
                      onPressed: () {
                        if (widget.babyInfo.infoId != null) {
                          babyProvider
                              .deleteBabyRecord(widget.babyInfo.infoId!);
                        }
                      },
                      child: Text(
                        'Delete a child',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade300,
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
                      onPressed: () {},
                      child: Text(
                        'Edit a child',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade300,
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
