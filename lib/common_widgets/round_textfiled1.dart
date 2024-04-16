import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

class RoundTextFiled1 extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintext;
  final String icon;
  final Widget? rightIcon;
  final EdgeInsets? margin;
  final bool obscureText;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const RoundTextFiled1(
      {super.key,
      this.controller,
      required this.hintext,
      required this.icon,
      this.margin,
      this.keyboardType,
      this.obscureText = false,
      this.rightIcon,
      this.onTap,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintext,
          suffixIcon: rightIcon,
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: Tcolor.gray,
            ),
          ),
          hintStyle: TextStyle(
            color: Tcolor.black,
            fontSize: 12,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
