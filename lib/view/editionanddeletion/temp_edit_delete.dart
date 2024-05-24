import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/healthActivites.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/shapes/temp3.dart';
import 'package:baba_tracker/shapes/temp4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class TempEdit extends StatefulWidget {
  final TempData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  TempEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _TempEditState createState() => _TempEditState();
}

class _TempEditState extends State<TempEdit> {
  Crud crud = Crud();
  late DateTime? date;
  late String type;
  late double temp;
  late String note;
  late TextEditingController noteController;
  late TempProvider tempProvider;
  final ValueNotifier<double> temperature = ValueNotifier(0.5);

  @override
  void initState() {
    super.initState();
    date = widget.entryData.date;
    temp = widget.entryData.temp!;
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    tempProvider = Provider.of<TempProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  Future<bool> _checkDuplicateTempData(DateTime startDate) async {
    List<TempData> existingData = await tempProvider.getTempRecords();
    bool duplicateExists = existingData.any((temp) =>
        temp.temp == temperature.value &&
        temp.date!.year == startDate.year &&
        temp.date!.month == startDate.month &&
        temp.date!.day == startDate.day &&
        temp.date!.hour == startDate.hour &&
        temp.date!.minute == startDate.minute);
    return duplicateExists;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    "Tempreture",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (widget.entryData.tempId != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Deletion"),
                              content: Text(
                                  "Are you sure you want to delete this record?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    tempProvider.deleteTempRecord(
                                        widget.entryData.tempId!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Durations.medium1,
                                        backgroundColor:
                                            Tcolor.gray.withOpacity(0.4),
                                        content: Text(
                                            "Record was successfully deleted."),
                                      ),
                                    );
                                    Navigator.of(context).pop();

                                    // Go back to the previous page
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red.shade200),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SliderTemperature(temperature),
                        Thermometer(temperature),
                      ],
                    ),
                    HealthWidget(
                      healthType: HealthType.Temp,
                      startDate: date,
                      controller: noteController,
                      onDateStratTimeChanged: (DateTime newStartDate) {
                        setState(() {
                          date = newStartDate;
                        });
                      },
                      onNoteChanged: (String note) {
                        noteController;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              RoundButton(
                  onpressed: () async {
                    if (widget.entryData.tempId != null) {
                      bool duplicateExists =
                          await _checkDuplicateTempData(date!);
                      if (duplicateExists) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/warning.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text(
                                  "Temprature data of the same  date, and hour already exists."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      } else {
                        tempProvider.editTempRecord(TempData(
                            date: date,
                            temp: temperature.value,
                            note: note,
                            tempId: widget.entryData.tempId));

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/change.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text(
                                  "Temprature Data was successfully updated."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  title: "Save changes"),
            ],
          ),
        ),
      ),
    );
  }
}
