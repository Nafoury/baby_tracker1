import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BalanceWeight extends StatefulWidget {
  const BalanceWeight({Key? key}) : super(key: key);

  @override
  State<BalanceWeight> createState() => _BalanceWeightState();
}

class _BalanceWeightState extends State<BalanceWeight> {
  final double min = 0;
  final double max = 100;
  String selectedValue = '';

  DateTime startDate = DateTime.now();

  @override
  void initState() {
    selectedValue = min.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        shape: BoxShape.rectangle,
        color: Colors.blue.withOpacity(0.1),
      ),
      child: GestureDetector(
        onTap: () {
          _showStartDatePicker(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd MMM yyyy').format(startDate),
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
            SizedBox(height: 30),
            AnimatedWeightPicker(
              selectedValueColor: Colors.blue.shade200,
              dialColor: Colors.blue.shade200,
              suffixTextColor: Colors.blue.shade200,
              min: min,
              max: max,
              onChange: (newValue) {
                setState(() {
                  selectedValue = newValue.toString();
                });
              },
            ),
          ],
        ),
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
                          setState(() {
                            startDate = newStartDate ?? startDate;
                          });
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
