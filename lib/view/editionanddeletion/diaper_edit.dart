import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../provider/diaper_provider.dart';

class DiaperEdit extends StatefulWidget {
  final DiaperData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  const DiaperEdit({
    super.key,
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _DiaperEditState createState() => _DiaperEditState();
}

class _DiaperEditState extends State<DiaperEdit> {
  late DiaperProvider diaperProvider;
  Crud crud = Crud();
  late DateTime startDate;
  late String status;
  late String note;
  late TextEditingController noteController;
  bool deleteData = true;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate;
    status = widget.entryData.status;
    note = widget.entryData.note;
    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateDiaperData(DateTime startDate) async {
    List<DiaperData> existingData = await diaperProvider.getMedicationRecords();
    bool duplicateExists = existingData.any((diaper) =>
        diaper.status == status &&
        diaper.startDate.year == startDate.year &&
        diaper.startDate.month == startDate.month &&
        diaper.startDate.day == startDate.day &&
        diaper.startDate.hour == startDate.hour &&
        diaper.startDate.minute == startDate.minute);
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
                      "Edit Diaper",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (widget.entryData.changeId != null) {
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
                                      await diaperProvider.deleteDiaperRecord(
                                          widget.entryData.changeId!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Column(
                      children: [
                        SizedBox(height: 20),
                        Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    );
                  },
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return GestureDetector(
                          onTap: () {
                            _showStartDatePicker(context, startDate);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(" Date & Time ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 13,
                                  )),
                              Text(
                                DateFormat('dd MMM yyyy  HH:mm')
                                    .format(startDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      case 1:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 80,
                                maxHeight: 25,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: ["poop", "pee", "mixed", "clean"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: Tcolor.gray,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: status,
                                  onChanged: (String? value) {
                                    print('Status changed: $value');
                                    setState(() {
                                      status = value!;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              status ?? 'None',
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        );
                      case 2:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                controller:
                                    noteController, // Use noteController here
                                onChanged: (newNote) {
                                  // Update the note variable when the text changes
                                  setState(() {
                                    note = newNote;
                                  });
                                },

                                decoration: const InputDecoration(
                                  hintText: "note",
                                ),
                              ),
                            ),
                          ],
                        );

                      default:
                        return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () async {
                      if (widget.entryData.changeId != null) {
                        bool duplicateExists =
                            await _checkDuplicateDiaperData(startDate);
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
                                    "Diaper data of the same type, date, and hour already exists."),
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
                          diaperProvider.editDiaperRecord(DiaperData(
                              startDate: startDate,
                              note: note,
                              status: status,
                              changeId: widget.entryData.changeId!));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Image.asset(
                                  "assets/images/change.png",
                                  height: 60,
                                  width: 60,
                                ),
                                content: Text(
                                    "Diaper Data was successfully updated."),
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
