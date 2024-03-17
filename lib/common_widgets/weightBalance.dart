import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:intl/intl.dart';

class BalanceWeight extends StatelessWidget {
  final double min;
  final double max;
  String? selectedValue;
  final DateTime? startDate;
  final Function(DateTime) onStartDateChanged;
  final Function(double) onWeightChanged;

  BalanceWeight({
    Key? key,
    required this.min,
    required this.max,
    this.selectedValue,
    this.startDate,
    required this.onStartDateChanged,
    required this.onWeightChanged,
  });

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
              DateFormat('dd MMM yyyy').format(startDate!),
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
                // newValue is the newly selected weight
                onWeightChanged(double.parse(newValue!));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStartDatePicker(BuildContext context) {
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: minimumDateTime,
      lastDate: maximumDateTime,
    ).then((pickedDate) {
      if (pickedDate != null) {
        onStartDateChanged(pickedDate);
      }
    });
  }
}
