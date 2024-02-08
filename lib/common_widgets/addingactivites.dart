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
  String? note;

  final Function(DateTime, DateTime)? onDateTimeChanged;
  final Function(DateTime)? onDateStratTimeChanged;
  late final TextEditingController noteController;
  final Function(String)? onStatusChanged;
  final Function(String)? onNoteChanged;
  String? selectedValue;
  String? dropdownError;
  final TextDirection? textDirection;

  TrackingWidget({
    required this.trackingType,
    this.feedingSubtype,
    this.startDate,
    this.endDate,
    this.status,
    this.textDirection,
    this.note,
    this.onDateTimeChanged,
    this.onDateStratTimeChanged,
    this.onStatusChanged,
    this.onNoteChanged,
  }) : noteController = TextEditingController(text: note ?? '');

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
                        controller: noteController,
                        onChanged: (String value) {
                          onNoteChanged?.call(value);
                        },
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: "note",
                          // Set your desired hint text
                        ),
                        //textAlign: TextAlign.start,
                      ),
                    ),
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
            itemCount: 5,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fruits ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 100, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            // Handle the user input here
                            // You can update the state or perform any necessary actions
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vegetables ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 100, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            // Handle the user input here
                            // You can update the state or perform any necessary actions
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Meat & Protein ",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 100, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            // Handle the user input here
                            // You can update the state or perform any necessary actions
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grains",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          )),
                      SizedBox(
                        width: 100, // Adjust the width as needed
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            // Handle the user input here
                            // You can update the state or perform any necessary actions
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          onChanged: (String value) {},
                          textAlign: TextAlign.left,
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
            });
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextField(
                          onChanged: (String value) {},
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: "note",
                            // Set your desired hint text
                          ),
                          //textAlign: TextAlign.start,
                        ),
                      ),
                    ],
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
