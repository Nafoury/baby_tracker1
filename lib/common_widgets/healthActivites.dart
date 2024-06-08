import 'dart:ffi';
import 'package:baba_tracker/common_widgets/nursingbuttons.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';

enum HealthType {
  Temp,
  vaccine,
  Medications,
}

class HealthWidget extends StatelessWidget {
  final HealthType healthType;
  final DateTime? startDate;
  final TextEditingController? controller;
  final Function(String)? onStatusChanged;
  final Function(String)? onNoteChanged;
  String? selectedValue;
  String? dropdownError;
  String? note;
  String? status;
  final Function(DateTime)? onDateStratTimeChanged;

  HealthWidget(
      {required this.healthType,
      this.startDate,
      this.controller,
      this.onNoteChanged,
      this.onStatusChanged,
      this.dropdownError,
      this.note,
      this.selectedValue,
      this.onDateStratTimeChanged,
      this.status});

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo(); // Call the method to build detailed tracking info UI
  }

  Widget _buildTrackingInfo() {
    switch (healthType) {
      case HealthType.Temp:
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
                      _showStartDatePicker(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" Date & Time ",
                            style: TextStyle(
                                color: Tcolor.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
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

      case HealthType.vaccine:
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
                                fontWeight: FontWeight.w700)),
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
                        maxWidth: 100,
                        maxHeight: 25,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: [
                            "HepB (Hepatitis B)",
                            "DTaP (Diphtheria, Tetanus, Pertussis)",
                            "IPV (Inactivated Poliovirus)",
                            "Hib (Haemophilus influenza type b)",
                            "MMR (Meales, Mumps , Rubella)",
                            "HepA (Hepatitis A)",
                            "Varicella  (Chicken pox)",
                            "RV (Rortavirus)",
                            "PCV (Pneumococcal)",
                            "Influenza",
                            "Encephalities",
                            "TB",
                          ]
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
                            'Vaccine type',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${status ?? 'None'}',
                      style: TextStyle(
                        fontSize: 12,
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
                      ),
                    ))
                  ],
                );

              default:
                return SizedBox();
            }
          },
        );
      case HealthType.Medications:
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
                                fontWeight: FontWeight.w700)),
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
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 100,
                          maxHeight: 35,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: [
                              "Drops",
                              "Sprays",
                              "Pain-relief",
                              "Anti-fever",
                              "Anti-inflammatory",
                              "Antibiotics",
                              "Probiotics",
                              "Antiseptic",
                              "Vitamin C",
                              "Vitamin D"
                            ]
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
                            hint: const Text(
                              'choose Medication',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${status ?? 'None'}',
                      style: TextStyle(
                        fontSize: 13.0,
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
        Text("Type: $healthType"),
      ],
    );
  }

  void _showStartDatePicker(BuildContext context) {
    DateTime? newStartDate = startDate;
    DateTime? initialDateTime = startDate;
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now().add(const Duration(days: 40));

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
}
