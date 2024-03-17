import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/momController.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:baby_tracker/view/charts/sleepchart.dart';
import 'package:baby_tracker/view/charts/weightChartMom.dart';
import 'package:baby_tracker/view/subTrackingPages/momweight.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';

class WeightTracking extends StatelessWidget {
  const WeightTracking({super.key});

  @override
  Widget build(BuildContext context) {
    MomController momController = MomController();
    return Scaffold(
        backgroundColor: Tcolor.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
                child: SafeArea(
                    child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed("/mainTab");
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
              FutureBuilder(
                future: momController.retrieveWeightData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final List<MomData> weightRecords = snapshot.data!;
                    final List<Map<String, dynamic>> weightDataAsMap =
                        weightRecords.map((weight) => weight.toJson()).toList();
                    return AspectRatio(
                        aspectRatio: 0.9,
                        child: WeightChart(weightRecords: weightDataAsMap));
                  }

                  return Container();
                },
              ),
              RoundButton(
                  onpressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeightPage()),
                    );
                  },
                  title: "Add weight")
            ])))));
  }
}
