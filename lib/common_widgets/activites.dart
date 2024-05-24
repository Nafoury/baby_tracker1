import 'package:flutter/material.dart';

import 'package:baba_tracker/common/color_extension.dart';

class Activites extends StatelessWidget {
  final Map aobj;
  final int index;
  final VoidCallback onPressed;

  const Activites(
      {super.key,
      required this.index,
      required this.aobj,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    Color color1 = Colors.transparent;
    Color color2 = Colors.transparent;

    if (index == 0) {
      color1 = Tcolor.primaryColor2.withOpacity(0.4);
      color2 = Tcolor.primaryColor1.withOpacity(0.4);
    } else if (index == 1) {
      color1 = Tcolor.light2gray.withOpacity(0.3);
      color2 = Tcolor.light1gray.withOpacity(0.3);
    } else if (index == 2) {
      color1 = Tcolor.pink1.withOpacity(0.2);
      color2 = Tcolor.pink2.withOpacity(0.2);
      // Add more conditions for other buttons if needed
    }
    return SizedBox(
      width: 130,
      height: 150,
      child: Container(
        //color: Tcolor.black,
        child: LayoutBuilder(builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;
          double innerWidth = constraints.maxWidth;
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Container(
                  height: innerHeight * 0.9,
                  margin: const EdgeInsets.all(3),
                  width: innerWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color1, color2],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                  ),
                ),
              ),
              Positioned(
                top: 160,
                left: 45,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add, color: Colors.grey),
                    iconSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        aobj["image"].toString(),
                        width: media.width * 0.15,
                        height: media.width * 0.15,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        aobj["activityname"].toString(),
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        aobj["subtitle"].toString(),
                        style: TextStyle(
                            color: Tcolor.gray,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
