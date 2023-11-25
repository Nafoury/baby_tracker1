import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String icon;
  final String selectedicon;
  final VoidCallback onTap;
  final bool isActive;

  const TabButton(
      {super.key,
      required this.icon,
      required this.selectedicon,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isActive ? selectedicon : icon,
              width: 25,
              height: 25,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: isActive ? 8 : 12,
            ),
            if (isActive)
              Container(
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: Tcolor.secondryG),
                    borderRadius: BorderRadius.circular(2),
                  ))
          ],
        ));
  }
}
