import 'package:baby_tracker/common_widgets/addingactivites.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/volumebottle.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/provider/bottleDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:provider/provider.dart';

class BottleEdit extends StatefulWidget {
  final BottleData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  const BottleEdit({
    super.key,
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _BottleEditState createState() => _BottleEditState();
}

class _BottleEditState extends State<BottleEdit> {
  late BottleDataProvider bottleDataProvider;
  Crud crud = Crud();
  late DateTime startDate;
  late double amount;
  late String note;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate!;
    amount = widget.entryData.amount!;
    note = widget.entryData.note!;
    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    bottleDataProvider =
        Provider.of<BottleDataProvider>(context, listen: false);
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
                      "Bottle",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.feed1Id != null) {
                          bottleDataProvider
                              .deleteBottleRecord(widget.entryData.feed1Id!);
                        }
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    BabyBottleSelector(onMlValueChanged: (double value) {
                      setState(() {
                        amount = value;
                      });
                    }),
                    SizedBox(height: 20),
                    TrackingWidget(
                      trackingType: TrackingType.Feeding,
                      feedingSubtype: FeedingSubtype.bottle,
                      controller: noteController,
                      startDate: startDate,
                      onDateStratTimeChanged: (DateTime newStartDate) {
                        setState(() {
                          startDate = newStartDate;
                        });
                      },
                      onNoteChanged: (String note) {
                        note = note;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      bottleDataProvider.editBottlerRecord(BottleData(
                        startDate: startDate,
                        amount: amount,
                        note: note,
                        feed1Id: widget.entryData.feed1Id,
                      ));
                    },
                    title: "Save changes")
              ],
            ),
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
                widget.onDateStratTimeChanged?.call(startDate);
              });
            },
          ),
        );
      },
    );
  }
}
