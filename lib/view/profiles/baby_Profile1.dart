import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_textfiled1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyProfile1 extends StatelessWidget {
  final DateTime? startDate;
  final TextEditingController? nameController;
  final TextEditingController? weightController1;
  final TextEditingController? heightController;
  final TextEditingController? headController;
  final TextEditingController? date;
  DateTime? selectedDate;
  final Function(String?)? onStatusChanged;
  final Function(DateTime) onStartDateChanged;
  String? selectedValue;
  String? dropdownError;
  String? status;
  BabyProfile1({
    Key? key,
    this.startDate,
    this.nameController,
    this.headController,
    this.heightController,
    this.weightController1,
    this.dropdownError,
    this.onStatusChanged,
    this.selectedValue,
    this.status,
    this.date,
    this.selectedDate,
    required this.onStartDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(
        color: Colors.grey.shade300,
      ),
      Text(
        'Details',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      RoundTextFiled1(
        hintext: 'name',
        icon: "assets/images/profile.png",
        controller: nameController,
      ),
      Divider(
        color: Colors.grey.shade300,
        height: 2,
      ),
      Container(
        decoration: BoxDecoration(
            color: Tcolor.lightgray, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset(
                "assets/images/user_gender.png",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                color: Tcolor.gray,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    maxHeight: 25,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: ["Female", "Male"]
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
                        onStatusChanged?.call(value);
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      hint: const Text(
                        'Choose gender',
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
            ),
          ],
        ),
      ),
      SizedBox(
        height: 5,
      ),
      GestureDetector(
        onTap: () => selectDate(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Tcolor.gray.withOpacity(0.3),
              ),
              SizedBox(width: 12),
              Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : 'Date of Birth',
                style: TextStyle(
                  fontSize: 12,
                  color: selectedDate != null ? Colors.black : Tcolor.gray,
                ),
              ),
            ],
          ),
        ),
      ),
      Divider(
        thickness: 3,
        color: Colors.grey.shade300,
      ),
      Text(
        'Measurements',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      Row(
        children: [
          Expanded(
            child: RoundTextFiled1(
                hintext: "Baby Weight",
                icon: "assets/images/weight-scale.png",
                keyboardType: TextInputType.number,
                controller: weightController1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "baby weight is required";
                  }
                  return null;
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Tcolor.secondryG,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "KG",
                style: TextStyle(color: Tcolor.white, fontSize: 12),
              )),
        ],
      ),
      Divider(
        color: Colors.grey.shade300,
      ),
      Row(
        children: [
          Expanded(
            child: RoundTextFiled1(
                hintext: "Baby Height",
                controller: heightController,
                icon: "assets/images/height_icon.png",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "baby height is required";
                  }
                  return null;
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Tcolor.secondryG,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "CM",
                style: TextStyle(color: Tcolor.white, fontSize: 12),
              )),
        ],
      ),
      Divider(
        color: Colors.grey.shade300,
      ),
      Row(
        children: [
          Expanded(
            child: RoundTextFiled1(
                hintext: "Baby head",
                icon: "assets/images/height_icon.png",
                controller: headController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "baby height is required";
                  }
                  return null;
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Tcolor.secondryG,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "CM",
                style: TextStyle(color: Tcolor.white, fontSize: 12),
              )),
        ],
      ),
      SizedBox(height: 20),
    ]);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      onStartDateChanged(picked);
      // Update selectedDate after picking a date
      selectedDate = picked;
    }
  }
}
