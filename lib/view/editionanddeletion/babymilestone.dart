import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/controller/milesStonesController.dart';
import 'package:baba_tracker/models/milestonesModel.dart';
import 'package:baba_tracker/view/more/milestones.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baba_tracker/common/color_extension.dart';

class MileStoneEdit extends StatefulWidget {
  final MilestoneData entryData;

  MileStoneEdit({
    required this.entryData,
  });

  @override
  _MileStoneEditState createState() => _MileStoneEditState();
}

class _MileStoneEditState extends State<MileStoneEdit> {
  Crud crud = Crud();
  late DateTime? date;
  late String label;
  late int id;
  final MileStonesController mileStonesController = new MileStonesController();

  @override
  void initState() {
    super.initState();

    date = widget.entryData.date;
    label = widget.entryData.label!;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed('/milestone');
                    },
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "Edit Milestone",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // An invisible widget to balance the layout
                  SizedBox(width: 25),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: media.height * 0.4,
                width: media.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: Tcolor.fourthG),
                  borderRadius: BorderRadius.circular(media.width * 0.07),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/dots_lighter.png",
                        height: media.width * 0.4,
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickDate(context);
                            },
                            child: Text(
                              DateFormat('dd MMM yyyy').format(date!),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        left: 135,
                        child: TextButton(
                            onPressed: () async {
                              print(widget.entryData.milestoneId);
                              if (widget.entryData.milestoneId != null) {
                                await mileStonesController.deleteData(
                                  widget.entryData.milestoneId!,
                                );
                              }
                            },
                            child: Text("clear")))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      print(pickedDate);
      await mileStonesController.editData(MilestoneData(
          date: pickedDate, milestoneId: widget.entryData.milestoneId));
    }
  }
}
