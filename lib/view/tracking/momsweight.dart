import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/models/momweightData.dart';
import 'package:baba_tracker/provider/momWeightProvider.dart';
import 'package:baba_tracker/view/charts/weightChartMom.dart';
import 'package:baba_tracker/view/subTrackingPages/momweight.dart';
import 'package:baba_tracker/view/summary/momWeightTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MomWeightpage extends StatefulWidget {
  const MomWeightpage({super.key});

  @override
  State<MomWeightpage> createState() => _MomWeightpageState();
}

class _MomWeightpageState extends State<MomWeightpage> {
  late MomWeightProvider momWeightProvider;
  late List<MomData> weightRecords = [];

  @override
  void didChangeDependencies() {
    momWeightProvider = Provider.of<MomWeightProvider>(context, listen: false);
    super.didChangeDependencies();
    fetchWeightRecords(momWeightProvider);
  }

  Future<void> fetchWeightRecords(MomWeightProvider momWeightProvider) async {
    try {
      List<MomData> records = await momWeightProvider.getWeightRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        weightRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: SingleChildScrollView(
            child: SafeArea(
                child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/images/back_Navs.png",
                  width: 25,
                  height: 25,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                width: 70,
              ),
              Text(
                "Mom's weight",
                style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<MomWeightProvider>(
            builder: (context, momweightProvider, child) {
              return Column(children: [
                WeightChart(weightRecords: weightRecords),
                SizedBox(
                  height: 40,
                ),
                RoundButton(
                    onpressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeightPage()),
                      );
                    },
                    title: "Add Weight"),
                SizedBox(
                  height: 40,
                ),
                WeightDataTable(weightRecords: weightRecords)
              ]);
            },
          ),
        ]))));
  }
}
