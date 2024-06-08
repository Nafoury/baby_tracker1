import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:intl/intl.dart';

class BalanceWeight extends StatefulWidget {
  final double min;
  final double max;
  final DateTime? startDate;
  final Function(DateTime) onStartDateChanged;
  final Function(double) onWeightChanged;
  final double initialWeight;
  final Widget? suffix;

  BalanceWeight({
    Key? key,
    required this.min,
    required this.max,
    this.startDate,
    required this.onStartDateChanged,
    required this.onWeightChanged,
    required this.initialWeight,
    this.suffix,
  }) : super(key: key);

  @override
  _BalanceWeightState createState() => _BalanceWeightState();
}

class _BalanceWeightState extends State<BalanceWeight> {
  late double selectedWeight;

  @override
  void initState() {
    super.initState();
    selectedWeight = widget.initialWeight; // Initialize with the initial weight
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
              DateFormat('dd MMM yyyy').format(widget.startDate!),
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
            SizedBox(height: 30),
            Text(
              selectedWeight.toStringAsFixed(2), // Display the selected weight
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 30),
            AnimatedWeightPicker(
              suffix: widget.suffix,
              selectedValueColor: Colors.blue.shade200,
              dialColor: Colors.blue.shade200,
              suffixTextColor: Colors.blue.shade200,
              min: widget.min,
              max: widget.max,
              onChange: (newValue) {
                setState(() {
                  selectedWeight =
                      double.parse(newValue!); // Update the selected weight
                });
                widget.onWeightChanged(selectedWeight);
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
      initialDate: widget.startDate!,
      firstDate: minimumDateTime,
      lastDate: maximumDateTime,
    ).then((pickedDate) {
      if (pickedDate != null) {
        widget.onStartDateChanged(pickedDate);
      }
    });
  }
}
