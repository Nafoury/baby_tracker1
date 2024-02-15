import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';

class Diaperchnage extends StatelessWidget {
  final DateTime? startDate;

  String? status;
  final TextEditingController? controller;
  final Function(DateTime, DateTime)? onDateTimeChanged;
  final Function(DateTime)? onDateStratTimeChanged;
  final Function(String)? onStatusChanged;
  final Function(String)? onNoteChanged;
  String? selectedValue;
  String? dropdownError;

  Diaperchnage(
      {this.controller,
      this.startDate,
      this.status,
      this.onDateTimeChanged,
      this.onDateStratTimeChanged,
      this.onStatusChanged,
      this.onNoteChanged});

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo(); // Call the method to build detailed tracking info UI
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SafeArea(
                    child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(width: 85),
                      Text(
                        "Feeding",
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 0.05,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                                _showStartDatePicker(
                                    context); // Show date picker for start date
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(" Date & Time ",
                                      style: TextStyle(
                                        color: Tcolor.black,
                                        fontSize: 13,
                                      )),
                                  Text(
                                    DateFormat('dd MMM yyyy  HH:mm')
                                        .format(startDate!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ));
                        case 1:
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth:
                                      80, // Adjust maximum width of the box
                                  maxHeight:
                                      25, // Adjust maximum height of the box
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
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      selectedValue = value;
                                      dropdownError = null;
                                      status = value;
                                      onStatusChanged?.call(value!);
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
                                '${status ?? 'None'}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  // fontWeight: FontWeight.bold,
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
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: "note",
                                  // Set your desired hint text
                                ),
                              ))
                            ],
                          );

                        default:
                          return SizedBox();
                      }
                    },
                  ),
                ])))));
    // Add more cases for other tracking types
  }

  void _showStartDatePicker(BuildContext context) {
    DateTime? newStartDate = startDate;
    DateTime? initialDateTime = startDate;
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now(); // You can adjust this if needed

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 200,
              color: Colors.white,
              child: Stack(
                children: [
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initialDateTime ?? DateTime.now(),
                    minimumDate: minimumDateTime,
                    maximumDate: maximumDateTime,
                    onDateTimeChanged: (DateTime? newDateTime) {
                      setState(() {
                        if (newDateTime != null) {
                          newStartDate = newDateTime;
                          onDateStratTimeChanged?.call(newStartDate!);
                        }
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Done'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }
}
