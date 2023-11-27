import 'dart:io';

import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:baby_tracker/view/on_boarding/on_boarding_view.dart';
import 'package:baby_tracker/view/on_boarding/started_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAuVgA99gzuJCwmoeTUPdNz472EyYpXwy4",
              appId: "1:463061599891:android:ef6934e6d4e96155cdaf66",
              messagingSenderId: "463061599891",
              projectId: "babytracker1-fffae"),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Tracker',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Tcolor.primaryColor1, fontFamily: "Poppins"),
      home: const Completeinfo(),
    );
  }
}
