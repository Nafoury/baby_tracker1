import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/models/babyWeight.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/provider/momWeightProvider.dart';
import 'package:baby_tracker/provider/weightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

import 'package:provider/provider.dart';

class BabyWeightEdit extends StatefulWidget {
  final WeightData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  BabyWeightEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _BabyWeightEditState createState() => _BabyWeightEditState();
}

class _BabyWeightEditState extends State<BabyWeightEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late double mlvalue;
  late WeightProvider weightProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    mlvalue = widget.entryData.weight!.toDouble();
  }

  @override
  void didChangeDependencies() {
    weightProvider = Provider.of<WeightProvider>(context, listen: false);
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
                      "Edit Weight",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.weightId != null) {
                          weightProvider
                              .deleteWeigthRecord(widget.entryData.weightId!);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red.shade200),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                BalanceWeight(
                    max: 200,
                    min: 0,
                    startDate: startDate,
                    onStartDateChanged: (DateTime newStartDate) {
                      setState(() {
                        startDate = newStartDate;
                      });
                    },
                    onWeightChanged: (double value) {
                      setState(() {
                        mlvalue = value;
                      });
                    }),
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.weightId != null) {
                        weightProvider.editWeightRecord(WeightData(
                            date: startDate,
                            weight: mlvalue,
                            weightId: widget.entryData.weightId!));
                      }
                      Navigator.pop(context);
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
