import 'package:baba_tracker/common_widgets/addingactivites.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/volumebottle.dart';
import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/bottleDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/widgets.dart';
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
  late BabyProvider babyProvider;

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
    bottleDataProvider = Provider.of<BottleDataProvider>(context, listen: true);
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateBottleData(DateTime startDate) async {
    List<BottleData> existingData = await bottleDataProvider.getBottleRecords();
    bool duplicateExists = existingData.any((bottle) =>
        bottle.amount == amount &&
        bottle.startDate!.year == startDate.year &&
        bottle.startDate!.month == startDate.month &&
        bottle.startDate!.day == startDate.day &&
        bottle.startDate!.hour == startDate.hour &&
        bottle.startDate!.minute == startDate.minute);
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                Text(
                  "Edit bottle",
                  style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (widget.entryData.feed1Id != null) {
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
                                  bottleDataProvider.deleteBottleRecord(
                                      widget.entryData.feed1Id!);
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
              ]),
              Column(
                children: [
                  BabyBottleSelector(
                    initialMlValue: amount, // Pass the initial amount
                    onMlValueChanged: (double value) {
                      setState(() {
                        amount = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TrackingWidget(
                      userBirthDate: babyProvider.activeBaby!.dateOfBirth!,
                      trackingType: TrackingType.Feeding,
                      feedingSubtype: FeedingSubtype.bottle,
                      controller: noteController,
                      startDate: startDate,
                      onDateStratTimeChanged: (DateTime newStartDate) {
                        setState(() {
                          startDate = newStartDate;
                        });
                      },
                      onNoteChanged: (String newNote) {
                        setState(() {
                          note = newNote;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              RoundButton(
                  onpressed: () async {
                    if (widget.entryData.feed1Id != null) {
                      bool duplicateExists =
                          await _checkDuplicateBottleData(startDate);
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
                                  "Bottle data of the same type, date, and hour already exists."),
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
                        bottleDataProvider.editBottlerRecord(BottleData(
                          startDate: startDate,
                          amount: amount,
                          note: note,
                          feed1Id: widget.entryData.feed1Id,
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
                                  Text("Bottle Data was successfully updated."),
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
                widget.onDateStratTimeChanged?.call(startDate);
              });
            },
          ),
        );
      },
    );
  }
}
