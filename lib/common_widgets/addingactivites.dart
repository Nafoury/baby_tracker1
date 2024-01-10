import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';

enum TrackingType {
  Sleeping,
  Feeding,
  Diaper,
  // Add more tracking types as needed
}

class TrackingWidget extends StatelessWidget {
  final TrackingType trackingType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? note;
  final bool summaryOnly;
  final Function(DateTime, DateTime)? onDateTimeChanged;

  TrackingWidget(
      {required this.trackingType,
      this.startDate,
      this.endDate,
      this.status,
      this.note,
      required this.summaryOnly,
      this.onDateTimeChanged});

  @override
  Widget build(BuildContext context) {
    if (summaryOnly) {
      return _buildSummary(); // Call the method to build summary UI
    } else {
      return _buildTrackingInfo(); // Call the method to build detailed tracking info UI
    }
  }

  Widget _buildTrackingInfo() {
    switch (trackingType) {
      case TrackingType.Sleeping:
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return const Column(
              children: [
                SizedBox(height: 25),
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
                      _showDatePicker(
                          context, true); // Show date picker for start date
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Start Date & Time ",
                            style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 12,
                            )),
                        Text(
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ));

              case 1:
                return GestureDetector(
                  onTap: () {
                    _showDatePicker(
                        context, false); // Show date picker for start date
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("End Date & Time ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 13,
                          )),
                      Text(
                        DateFormat('dd MMM yyyy  HH:mm').format(endDate!),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              case 2:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Duration "),
                    Text(_formattedDuration(endDate!.difference(startDate!))),
                  ],
                );
              default:
                return SizedBox();
            }
          },
        );
      case TrackingType.Feeding:
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return const Column(
              children: [
                SizedBox(height: 25),
                Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ],
            );
          },
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return GestureDetector(
                    onTap: () {
                      _showDatePicker(
                          context, true); // Show date picker for start date
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" Date & Time ",
                            style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 12,
                            )),
                        Text(
                          DateFormat('dd MMM yyyy  HH:mm:ss')
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
                    Text("Fruits ",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 13,
                        )),
                    const Text(
                      "0g",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              case 2:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vegetables "),
                    Text("0g"),
                  ],
                );
              case 3:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meat &Protein "),
                    Text("0g"),
                  ],
                );
              case 4:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Grains "),
                    Text("0g"),
                  ],
                );

              default:
                return SizedBox();
            }
          },
        );
      case TrackingType.Diaper:
        return ListView.separated(
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
                      _showDatePicker(
                          context, true); // Show date picker for start date
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" Date & Time ",
                            style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 12,
                            )),
                        Text(
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ));
              case 1:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 80, // Adjust maximum width of the box
                          maxHeight: 25, // Adjust maximum height of the box
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          value: status,
                          onChanged: (String? newValue) {
                            // Implement logic to update the status value
                            // For instance, you can use setState to update the status value
                          },
                          items: <String>['pee', 'poop', 'mixed', 'clean']
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(value),
                                    if (value == status)
                                      Icon(Icons.check, color: Colors.green),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          hint: const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))),
                  ],
                );

              case 2:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Note "),
                    Text("$note"),
                  ],
                );
              default:
                return SizedBox();
            }
          },
        );
      // Add more cases for other tracking types
      default:
        return _buildDefaultInfo(); // Fallback to a default info if type doesn't match
    }
  }

  Widget _buildSummary() {
    switch (trackingType) {
      case TrackingType.Sleeping:
      case TrackingType.Feeding:
      // Your implementation for Feeding type
      case TrackingType.Diaper:
      // Your implementation for Diaper type
      // Add more cases for other tracking types
      default:
        return Container(); // Fallback to an empty container for summary if type doesn't match
    }
  }

  Widget _buildDefaultInfo() {
    // Default info widget in case of unmatched type
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Default Info"),
        Text("Type: $trackingType"),
      ],
    );
  }

  void _showDatePicker(BuildContext context, bool isStartDate) {
    DateTime? newStartDate = startDate;
    DateTime? newEndDate = endDate;
    DateTime? initialDateTime = isStartDate ? startDate : endDate;
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40)); // Previous date
    DateTime maximumDateTime = DateTime.now(); // Current date

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
                          if (isStartDate) {
                            newStartDate = newDateTime;
                          } else {
                            newEndDate = newDateTime;
                          }
                          if (newStartDate != null && newEndDate != null) {
                            Duration duration =
                                newEndDate!.difference(newStartDate!);
                            onDateTimeChanged?.call(newStartDate!, newEndDate!);
                          }
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
