import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/controller/faceDayController.dart';
import 'package:baba_tracker/models/faceModel.dart';
import 'package:baba_tracker/view/more/fac_days1.dart';
import 'package:flutter/material.dart';

class FaceAday extends StatelessWidget {
  const FaceAday({super.key});

  @override
  Widget build(BuildContext context) {
    FaceDayController faceDayController = new FaceDayController();
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
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
                      width: 75,
                    ),
                    Text(
                      "Face A day",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Wrap the GridView.builder inside a Container with a height constraint
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.9, // Adjust the percentage as needed
                  child: FutureBuilder<List<FaceData>>(
                    future: faceDayController.retrievefaceData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<FaceData> faceDataList = snapshot.data ?? [];
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: 30, // or however many items you want
                          itemBuilder: (context, index) {
                            return DayItem(
                              faceData: index < faceDataList.length
                                  ? faceDataList[index]
                                  : FaceData(), // Use empty FaceData if index exceeds list length
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
