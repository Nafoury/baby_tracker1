import 'dart:io';
import 'package:baby_tracker/Services/notifi_service.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
import 'package:baby_tracker/provider/bottleDataProvider.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:baby_tracker/provider/medications_provider.dart';
import 'package:baby_tracker/provider/momWeightProvider.dart';
import 'package:baby_tracker/provider/nursingDataProvider.dart';
import 'package:baby_tracker/provider/solids_provider.dart';
import 'package:baby_tracker/provider/tempProvider.dart';
import 'package:baby_tracker/provider/vaccine_provider.dart';
import 'package:baby_tracker/provider/weightProvider.dart';
import 'package:baby_tracker/view/home/diaper_change.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'package:baby_tracker/view/login/login_page.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:baby_tracker/view/on_boarding/on_boarding_view.dart';
import 'package:baby_tracker/view/on_boarding/started_view.dart';
import 'package:baby_tracker/view/tracking/feedinT.dart';
import 'package:baby_tracker/view/tracking/mainTracking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:baby_tracker/provider/sleep_provider.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
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
        ChangeNotifierProvider(create: (context) => BottleDataProvider()),
        ChangeNotifierProvider(create: (context) => SolidsProvider()),
        ChangeNotifierProvider(create: (context) => NursingDataProvider()),
        ChangeNotifierProvider(create: (context) => MedicationsProvider()),
        ChangeNotifierProvider(create: (context) => VaccineProvider()),
        ChangeNotifierProvider(create: (context) => DiaperProvider()),
        ChangeNotifierProvider(create: (context) => SleepProvider()),
        ChangeNotifierProvider(create: (context) => TempProvider()),
        ChangeNotifierProvider(create: (context) => MomWeightProvider()),
        ChangeNotifierProvider(create: (context) => WeightProvider()),
        ChangeNotifierProvider(create: (context) => BabyProvider()),
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
        GetPage(name: "/diaperchnage", page: () => DiaperChange()),
        GetPage(name: "/feedingTrack", page: () => FeedingTracking()),
        GetPage(name: "/trackingPage", page: () => TrackingPage()),
        GetPage(name: "/diaperchange", page: () => DiaperChange()),
        GetPage(name: "/trackingPage", page: () => TrackingPage()),
      ],
      routes: {"login": (context) => LoginPage()},
    );
  }
}
