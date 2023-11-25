import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

class DiaperChange extends StatefulWidget {
  const DiaperChange({super.key});

  @override
  State<DiaperChange> createState() => _DiaperChangeState();
}

class _DiaperChangeState extends State<DiaperChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
    );
  }
}
