import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';

class SleepingView extends StatefulWidget {
  const SleepingView({super.key});

  @override
  State<SleepingView> createState() => _SleepingViewState();
}

class _SleepingViewState extends State<SleepingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
    );
  }
}
