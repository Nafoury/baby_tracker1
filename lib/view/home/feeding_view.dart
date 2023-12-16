import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FeedingView extends StatefulWidget {
  const FeedingView({super.key});

  @override
  State<FeedingView> createState() => _FeedingViewState();
}

class _FeedingViewState extends State<FeedingView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
    );
  }
}
