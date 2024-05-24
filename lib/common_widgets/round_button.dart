import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';

enum RoundButtonType { bgGradiant, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onpressed;

  const RoundButton({
    super.key,
    required this.onpressed,
    required this.title,
    this.type = RoundButtonType.bgGradiant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: Tcolor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(25),
          boxShadow: type == RoundButtonType.bgGradiant
              ? const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.5,
                      offset: Offset(0, 0.5))
                ]
              : null),
      child: MaterialButton(
        onPressed: onpressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: Tcolor.primaryColor1,
        minWidth: double.maxFinite,
        elevation: type == RoundButtonType.bgGradiant ? 0 : 1,
        color: type == RoundButtonType.bgGradiant
            ? Colors.transparent
            : Tcolor.white,
        child: type == RoundButtonType.bgGradiant
            ? Text(
                title,
                style: TextStyle(
                  color: Tcolor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              )
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                          colors: Tcolor.primaryG,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      .createShader(
                    Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                  );
                },
                child: Text(
                  title,
                  style: TextStyle(
                      color: Tcolor.primaryColor1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
      ),
    );
  }
}
