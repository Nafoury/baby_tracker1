import 'dart:io';
import 'package:baba_tracker/Services/notifi_service.dart';
import 'package:baba_tracker/Services/workManager.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/provider/UserImageProvider.dart';
import 'package:baba_tracker/provider/babyHeadProvider.dart';
import 'package:baba_tracker/provider/babyHeightProvider.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/babyfaceDay.dart';
import 'package:baba_tracker/provider/bottleDataProvider.dart';
import 'package:baba_tracker/provider/diaper_provider.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/provider/momWeightProvider.dart';
import 'package:baba_tracker/provider/nursingDataProvider.dart';
import 'package:baba_tracker/provider/solids_provider.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
import 'package:baba_tracker/provider/weightProvider.dart';
import 'package:baba_tracker/view/home/diaper_change.dart';
import 'package:baba_tracker/view/home/home_view.dart';
import 'package:baba_tracker/view/login/complete_info.dart';
import 'package:baba_tracker/view/login/login_page.dart';
import 'package:baba_tracker/view/login/sign_up.dart';
import 'package:baba_tracker/view/login/updatepassword.dart';
import 'package:baba_tracker/view/main_tab/main_tab.dart';
import 'package:baba_tracker/view/more/face_day.dart';
import 'package:baba_tracker/view/more/mainMorePage.dart';
import 'package:baba_tracker/view/more/milestones.dart';
import 'package:baba_tracker/view/on_boarding/on_boarding_view.dart';
import 'package:baba_tracker/view/on_boarding/started_view.dart';
import 'package:baba_tracker/view/profiles/mom_profile.dart';
import 'package:baba_tracker/view/tracking/feedinT.dart';
import 'package:baba_tracker/view/tracking/mainTracking.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:baba_tracker/provider/sleep_provider.dart';

late SharedPreferences sharedPref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  sharedPref = await SharedPreferences.getInstance();

  bool isLoggedIn = sharedPref.getBool('isLoggedIn') ?? false;

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
        ChangeNotifierProvider(create: (context) => HeadMeasureProvider()),
        ChangeNotifierProvider(create: (context) => UserImageProvider()),
        ChangeNotifierProvider(create: (context) => HeightMeasureProvider()),
        ChangeNotifierProvider(create: (context) => FaceDayProvider())
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
        GetPage(name: "/updatedPassword", page: () => UpdatedPassword()),
        GetPage(name: "/faceADay", page: () => FaceAday()),
        GetPage(name: "/morePage", page: () => MorePage()),
        GetPage(name: "/milestone", page: () => Milestones()),
        GetPage(name: "/momprofile", page: () => MomProfile()),
      ],
      routes: {"login": (context) => LoginPage()},
    );
  }
}
