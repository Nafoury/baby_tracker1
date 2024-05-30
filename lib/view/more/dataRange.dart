import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class DateRangeSelector extends StatelessWidget {
  final int selectedMonth;
  final Function(int) onMonthSelected;

  const DateRangeSelector({
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(12, (index) {
          int month = index + 1;
          return GestureDetector(
            onTap: () {
              onMonthSelected(month);
            },
            child: Column(
              children: [
                SizedBox(height: 4),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: selectedMonth == month
                      ? Tcolor.primaryColor1
                      : Colors.grey.shade300,
                  child: Text(
                    month.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
