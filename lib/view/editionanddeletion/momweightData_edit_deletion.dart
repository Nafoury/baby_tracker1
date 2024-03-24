import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/weightBalance.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/provider/momWeightProvider.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

import 'package:provider/provider.dart';

class MomWeightEdit extends StatefulWidget {
  final MomData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

  MomWeightEdit({
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _MomWeightEditState createState() => _MomWeightEditState();
}

class _MomWeightEditState extends State<MomWeightEdit> {
  Crud crud = Crud();
  late DateTime? startDate;
  late double mlvalue;
  late MomWeightProvider momWeightProvider;

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.date;
    mlvalue = widget.entryData.weight!.toDouble();
  }

  @override
  void didChangeDependencies() {
    momWeightProvider = Provider.of<MomWeightProvider>(context, listen: false);
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
                      "Add Weight",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.momId != null) {
                          momWeightProvider
                              .deleteWeigthRecord(widget.entryData.momId!);
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
                      if (widget.entryData.momId != null) {
                        momWeightProvider.editWeightRecord(MomData(
                            date: startDate,
                            weight: mlvalue,
                            momId: widget.entryData.momId!));
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
