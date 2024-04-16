import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/view/more/fac_days1.dart';
import 'package:flutter/material.dart';

class FaceAday extends StatelessWidget {
  const FaceAday({super.key});

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {},
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
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 90, // or however many days you want to display
                    itemBuilder: (context, index) {
                      return DayItem(index + 1);
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
