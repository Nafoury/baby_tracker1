import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TeethDropDown extends StatelessWidget {
  final DateTime? startDate;
  String? selectedValue;
  String? dropdownError;
  String? choice;
  String? selectedValue1;
  String? dropdownError1;
  String? choice1;
  final Function(String)? onStatusChanged;
  final Function(String)? onChoiceChanged;
  final Function(DateTime)? onDateStratTimeChanged;
  TeethDropDown(
      {super.key,
      required this.startDate,
      this.dropdownError,
      this.selectedValue,
      this.onStatusChanged,
      this.choice,
      this.onDateStratTimeChanged,
      this.choice1,
      this.dropdownError1,
      this.onChoiceChanged,
      this.selectedValue1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(children: [
            Image.asset(
              "assets/images/calendar.png",
              height: 20,
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                _showStartDatePicker(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    " Date & Time ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(startDate!),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(
            height: 20,
            child: Divider(
              color: Colors.grey.shade300,
              height: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upper',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 15,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: [
                            "Central incisor(L)",
                            "Lateral incisor(L)",
                            "Canine(L)",
                            "First molar(L)",
                            "Second Molar(L)",
                            "Central incisor(R)",
                            "Lateral incisor(R)",
                            "Canine(R)",
                            "First molar(R)",
                            "Second Molar(R)"
                          ].map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          value: selectedValue,
                          onChanged: (String? value) {
                            selectedValue = value;
                            dropdownError = null;
                            choice = value;
                            onStatusChanged?.call(value!);
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                        ),
                      ),
                    ),
                    Text(
                      '${choice ?? 'None'}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lower',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 15,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: [
                            "Central incisor(L)",
                            "Lateral incisor(L)",
                            "Canine(L)",
                            "First molar(L)",
                            "Second Molar(L)",
                            "Central incisor(R)",
                            "Lateral incisor(R)",
                            "Canine(R)",
                            "First molar(R)",
                            "Second Molar(R)"
                          ].map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          value: selectedValue1,
                          onChanged: (String? value) {
                            selectedValue1 = value;
                            dropdownError1 = null;
                            choice1 = value;
                            onChoiceChanged?.call(value!);
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                        ),
                      ),
                    ),
                    Text(
                      '${choice1 ?? 'None'}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
}
