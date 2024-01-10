import 'dart:io';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'package:baby_tracker/view/login/login_page.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:baby_tracker/view/on_boarding/on_boarding_view.dart';
import 'package:baby_tracker/view/on_boarding/started_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baby_tracker/models/completeinf.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  bool isLoggedIn = sharedPref.getBool('isLoggedIn') ?? false;

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAuVgA99gzuJCwmoeTUPdNz472EyYpXwy4",
              appId: "1:463061599891:android:ef6934e6d4e96155cdaf66",
              messagingSenderId: "463061599891",
              projectId: "babytracker1-fffae"),
        )
      : await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SleepDataProvider()),
        // Add more providers if needed
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby Tracker',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Tcolor.primaryColor1, fontFamily: "Poppins"),
      home: isLoggedIn ? MainTab() : Startview(),
      getPages: [
        GetPage(name: "/completeinfo", page: () => Completeinfo()),
        GetPage(name: "/home", page: () => HomeView()),
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(name: "/mainTab", page: () => MainTab()),
      ],
    );
  }
}
