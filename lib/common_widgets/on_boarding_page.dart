import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';

class OnBoardingPage extends StatelessWidget {
  final Map pages;
  const OnBoardingPage({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            pages["image"].toString(),
            width: media.width,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pages["title"].toString(),
              style: TextStyle(
                color: Tcolor.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pages["subtitle"].toString(),
              style: TextStyle(
                color: Tcolor.gray,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
