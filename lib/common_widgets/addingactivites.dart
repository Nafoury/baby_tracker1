import 'dart:ffi';
import 'package:baby_tracker/common_widgets/nursingbuttons.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';

enum TrackingType {
  Sleeping,
  Feeding,
  Diaper,
}

enum FeedingSubtype {
  solids,
  nursing,
  bottle,
}

class TrackingWidget extends StatelessWidget {
  final TrackingType trackingType;
  late FeedingSubtype? feedingSubtype;
  final DateTime? startDate;
  final DateTime? endDate;
  String? status;
  final TextEditingController? controller;
  final TextEditingController? controller1;
  final TextEditingController? controller2;
  final TextEditingController? controller3;
  final TextEditingController? controller4;
  final TextEditingController? controller5;
  final Function(DateTime, DateTime)? onDateTimeChanged;
  final Function(DateTime)? onDateStratTimeChanged;
  final Function(String)? onStatusChanged;
  final Function(String)? onNoteChanged;
  final Function(int)? onFruitChanged;
  final Function(int)? onVegChanged;
  final Function(int)? onDairyChanged;
  final Function(int)? onProteinChanged;
  final Function(int)? onGrainsChanged;
  String? selectedValue;
  String? dropdownError;
  String? note;
  int? fruit;
  int? garins;
  int? protein;
  int? veg;
  int? dairy;

  TrackingWidget({
    required this.trackingType,
    this.controller,
    this.controller1,
    this.controller2,
    this.controller3,
    this.controller4,
    this.controller5,
    this.feedingSubtype,
    this.startDate,
    this.endDate,
    this.status,
    this.note,
    this.onDateTimeChanged,
    this.onDateStratTimeChanged,
    this.onStatusChanged,
    this.onNoteChanged,
    this.onDairyChanged,
    this.onFruitChanged,
    this.onGrainsChanged,
    this.onProteinChanged,
    this.onVegChanged,
    this.selectedValue,
    this.dairy,
    this.fruit,
    this.garins,
    this.protein,
    this.veg,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo(); // Call the method to build detailed tracking info UI
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
                              fontSize: 13,
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
        return _buildFeedingSubtypeRow();

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
                      _showStartDatePicker(
                          context); // Show date picker for start date
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
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
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
                        maxWidth: 80, // Adjust maximum width of the box
                        maxHeight: 25, // Adjust maximum height of the box
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
                      onChanged: (String value) {
                        onNoteChanged?.call(value);
                        note:
                        value;
                      },
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
        );
      // Add more cases for other tracking types
      default:
        return _buildDefaultInfo(); // Fallback to a default info if type doesn't match
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

  Widget _buildFeedingSubtypeRow() {
    switch (feedingSubtype) {
      case FeedingSubtype.solids:
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
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return GestureDetector(
                      onTap: () {
                        _showStartDatePicker(
                            context); // Show date picker for start date
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" Date & Time ",
                              style: TextStyle(
                                  color: Tcolor.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ));

                case 1:
                  return Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .pink.shade100, // Customize the color as needed
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Fruits ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 275, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: controller1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            int intValue = int.parse(value);
                            onFruitChanged?.call(intValue);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "0g",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                case 2:
                  return Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .green.shade200, // Customize the color as needed
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Vegetables ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 233, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: controller2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            int intValue = int.parse(value);
                            onVegChanged?.call(intValue);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "0g",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                case 3:
                  return Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .brown.shade200, // Customize the color as needed
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Meat & Protein ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 205, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: controller3,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            int intValue = int.parse(value);
                            onProteinChanged?.call(intValue);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "0g",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                case 4:
                  return Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .blue.shade100, // Customize the color as needed
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Grains",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 270, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: controller4,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            int intValue = int.parse(value);
                            onGrainsChanged?.call(intValue);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "0g",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                case 5:
                  return Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors
                              .blue.shade100, // Customize the color as needed
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Dairy",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 270, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          controller: controller5,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            int intValue = int.parse(value);
                            onDairyChanged?.call(intValue);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "0g",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  );
                case 6:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: TextField(
                        controller: controller,
                        onChanged: (String value) {
                          onNoteChanged?.call(value);
                          note:
                          value;
                        },
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
            });
      case FeedingSubtype.bottle:
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
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return GestureDetector(
                    onTap: () {
                      _showStartDatePicker(
                          context); // Show date picker for start date
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" Date & Time ",
                            style: TextStyle(
                                color: Tcolor.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                        Text(
                          DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ));
              case 1:
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "note",
                          // Set your desired hint text
                        ),
                        //textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                );
            }
          },
        );
      case FeedingSubtype.nursing:
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
                  return RoundButton1();

                case 1:
                  return GestureDetector(
                      onTap: () {
                        _showStartDatePicker(
                            context); // Show date picker for start date
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" Date & Time ",
                              style: TextStyle(
                                  color: Tcolor.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            DateFormat('dd MMM yyyy  HH:mm').format(startDate!),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ));

                case 2:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  );
                default:
                  return SizedBox();
              }
            });
      default:
        return _buildDefaulttype();
    }
  }

  Widget _buildDefaulttype() {
    // Default info widget in case of unmatched type
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Default Info"),
        Text("Type: $feedingSubtype"),
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
