import 'dart:ffi';
import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

import '../../provider/diaper_provider.dart';

class SleepEdit extends StatefulWidget {
  final SleepData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  const SleepEdit({
    super.key,
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _SleepEditState createState() => _SleepEditState();
}

class _SleepEditState extends State<SleepEdit> {
  late SleepProvider sleepProvider;
  Crud crud = Crud();
  late DateTime startDate;
  late DateTime endDate;
  late String status;
  late String note;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate ?? DateTime.now();
    endDate = widget.entryData.endDate ?? DateTime.now();
    note = widget.entryData.note.toString();

    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    super.didChangeDependencies();
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
                      "Edit Sleep",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.sleepId != null) {
                          sleepProvider
                              .deleteSleepRecord(widget.entryData.sleepId!);
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
                TrackingWidget(
                  trackingType: TrackingType.Sleeping,
                  startDate: startDate,
                  endDate: endDate,
                  controller: noteController,
                  onDateTimeChanged:
                      (DateTime newStartDate, DateTime newEndDate) {
                    setState(() {
                      startDate = newStartDate;
                      endDate = newEndDate;
                    });
                  },
                  onNoteChanged: (String note) {
                    noteController;
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.sleepId != null) {
                        sleepProvider.editSleepRecord(SleepData(
                            startDate: startDate,
                            endDate: endDate,
                            note: note,
                            sleepId: widget.entryData.sleepId!));
                      }
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
