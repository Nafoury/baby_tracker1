import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

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
    var isEvent = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.all(3),
      width: media.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: isEvent
                ? [
                    Tcolor.primaryColor2.withOpacity(0.5),
                    Tcolor.primaryColor1.withOpacity(0.5)
                  ]
                : [
                    Tcolor.light1gray.withOpacity(0.5),
                    Tcolor.light2gray.withOpacity(0.5),
                  ]),
        borderRadius: const BorderRadius.all(Radius.circular(35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              aobj["subtitle"].toString(),
              style: TextStyle(
                  color: Tcolor.gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 12,
            ),
            CircleAvatar(
              backgroundColor: Tcolor.light1gray.withOpacity(0.3),
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                iconSize: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
