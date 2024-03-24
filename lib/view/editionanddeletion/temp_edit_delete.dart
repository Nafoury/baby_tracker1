import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/healthActivites.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:baby_tracker/models/tempData.dart';
import 'package:baby_tracker/provider/medications_provider.dart';
import 'package:baby_tracker/provider/tempProvider.dart';
import 'package:baby_tracker/shapes/temp3.dart';
import 'package:baby_tracker/shapes/temp4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/common/color_extension.dart';
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      onPressed: () {
                        if (widget.entryData.tempId != null) {
                          tempProvider
                              .deleteTempRecord(widget.entryData.tempId!);
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
                Column(
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
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.tempId != null) {
                        tempProvider.editTempRecord(TempData(
                            date: date,
                            temp: temperature.value,
                            note: note,
                            tempId: widget.entryData.tempId));
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
}
