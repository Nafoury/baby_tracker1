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
  DateTime startDate;
  DateTime endDate;
  final String? status;
  final String? note;
  final bool summaryOnly;

  TrackingWidget({
    required this.trackingType,
    required this.startDate,
    required this.endDate,
    this.status,
    this.note,
    required this.summaryOnly,
  });

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
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate),
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
                        context, true); // Show date picker for start date
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
                        DateFormat('dd MMM yyyy  HH:mm:ss').format(endDate),
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
                    Text("${endDate.difference(startDate).toString()}"),
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
            return Divider(
              color: Colors.grey,
              height: 1,
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
                          DateFormat('dd MMM yyyy  HH:mm:ss').format(startDate),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ));

              case 1:
                Row(
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
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vegetables "),
                    Text("0g"),
                  ],
                );
              case 3:
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meat &Protein "),
                    Text("0g"),
                  ],
                );
              case 4:
                return const Row(
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
            return Divider(
              color: Colors.grey,
              height: 1,
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
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ));

              case 1:
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status ",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 13,
                        )),
                    Text("pee"),
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
        Duration duration = endDate.difference(startDate);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(startDate),
                  style: TextStyle(
                    color: Tcolor.black.withOpacity(0.3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(width: 120), // Adjust the space between the columns
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Duration",
                  style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  duration.toString(),
                  style: TextStyle(
                    color: Tcolor.black.withOpacity(0.3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        );
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
    DateTime initialDateTime = isStartDate ? startDate : endDate;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              if (isStartDate) {
                // Update the start date
                // You may want to add additional logic to prevent end date before start date, etc.
                startDate = newDateTime;
              } else {
                // Update the end date
                endDate = newDateTime;
              }
            },
          ),
        );
      },
    );
  }
}
