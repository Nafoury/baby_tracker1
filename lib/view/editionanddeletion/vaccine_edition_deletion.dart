import 'dart:ffi';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:baby_tracker/provider/medications_provider.dart';
import 'package:baby_tracker/provider/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class VaccineEdit extends StatefulWidget {
  final VaccineData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  VaccineEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _VaccineEditState createState() => _VaccineEditState();
}

class _VaccineEditState extends State<VaccineEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late String type;
  late String note;
  late TextEditingController noteController;
  late VaccineProvider vaccineProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    type = widget.entryData.type.toString();
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    vaccineProvider = Provider.of<VaccineProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Get.offAllNamed("/mainTab");
                      },
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 85),
                    Text(
                      "Vaccine",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 48),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.vaccineId != null) {
                          vaccineProvider
                              .deleteVaccineRecord(widget.entryData.vaccineId!);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
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
                            _showStartDatePicker(context, startDate!);
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
                                DateFormat('dd MMM yyyy  HH:mm')
                                    .format(startDate!),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
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
                                    value: type,
                                    onChanged: (String? value) {
                                      print('Status changed: $value');
                                      setState(() {
                                        type = value!;
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text(
                                      'choose Medication',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${type ?? 'None'}',
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
                              controller: noteController,
                              onChanged: (newNote) {
                                setState(() {
                                  note = newNote;
                                });
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
                ),
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.vaccineId != null) {
                        vaccineProvider.editVaccineRecord(VaccineData(
                            date: startDate,
                            type: type,
                            note: note,
                            vaccineId: widget.entryData.vaccineId!));
                      }
                    },
                    title: "Save changes")
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStartDatePicker(BuildContext context, DateTime initialDateTime) {
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDateTime,
            minimumDate: minimumDateTime,
            maximumDate: maximumDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              print('New DateTime: $newDateTime');
              setState(() {
                startDate = newDateTime;
                print('Updated startDate: $startDate');
                widget.onDateStratTimeChanged?.call(startDate!);
              });
            },
          ),
        );
      },
    );
  }
}
