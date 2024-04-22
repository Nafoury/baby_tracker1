import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/teethController.dart';
import 'package:baby_tracker/models/teethModel.dart';
import 'package:baby_tracker/models/tempData.dart';
import 'package:baby_tracker/provider/tempProvider.dart';
import 'package:baby_tracker/shapes/temp3.dart';
import 'package:baby_tracker/shapes/temp4.dart';
import 'package:baby_tracker/view/more/toothPgae.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/common/color_extension.dart';
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      "Teeth",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.toothId != null) {
                          teethController
                              .deleteTeeth(widget.entryData.toothId!);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                TeethDropDown(
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
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.toothId != null) {
                        teethController.editTeeth(TeethData(
                          date: date,
                          upper: choice,
                          lower: choice1,
                          toothId: widget.entryData.toothId,
                        ));
                      }
                      print(date);
                      print(choice);
                      print(choice1);
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
