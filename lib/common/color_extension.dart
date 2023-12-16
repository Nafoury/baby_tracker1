import 'package:flutter/material.dart';

class Tcolor {
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondryColor1 => const Color(0xffC58BF2);
  static Color get secondryColor2 => const Color(0xffEEA4CE);

  static Color get light1gray => const Color(0xff7B6F72);
  static Color get light2gray => const Color(0xffADA4A5);

  static Color get pink1 => const Color(0xffEC8686);
  static Color get pink2 => const Color(0xffEE9696);

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondryG => [secondryColor2, secondryColor1];
  static List<Color> get thirdG => [light1gray, light2gray];
  static List<Color> get fourthG => [pink1, pink2];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff7B6F72);
  static Color get white => Colors.white;
  static Color get lightgray => const Color(0xffF7F8F8);
}
