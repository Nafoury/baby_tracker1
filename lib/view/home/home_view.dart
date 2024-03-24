import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/activites.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:baby_tracker/models/tempData.dart';
import 'package:baby_tracker/provider/bottleDataProvider.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:baby_tracker/provider/solids_provider.dart';
import 'package:baby_tracker/provider/tempProvider.dart';
import 'package:baby_tracker/view/home/diaper_change.dart';
import 'package:baby_tracker/view/home/feeding_view.dart';
import 'package:baby_tracker/view/home/sleeping_view.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'dart:async';
import 'package:baby_tracker/common_widgets/recentlyactivities.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late SharedPreferences sharedPref;
  late String weekText = '';
  late String babyname = '';
  late String firstName = '';
  late String dateOfBirthString = '';
  late List<DiaperData> diapersRecords = [];
  late List<SleepData> sleepRecords = [];
  late List<SolidsData> solidsRecords = [];
  late List<BottleData> bottleRecords = [];

  late DiaperProvider diaperProvider;
  late SleepProvider sleepProvider;
  late SolidsProvider solidsProvider;
  late BottleDataProvider bottleDataProvider;

  Future<void> fetchMedicationRecords(DiaperProvider diaperProvider) async {
    try {
      List<DiaperData> records = await diaperProvider.getMedicationRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        diapersRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

  Future<void> fetchSleepRecords(SleepProvider sleepProvider) async {
    try {
      List<SleepData> record = await sleepProvider.getSleepRecords();
      print('Fetched sleep Records: $record');
      setState(() {
        sleepRecords = record;
        print('Fetched sleep Records: $record');
      });
    } catch (e) {
      print('Error fetching sleep records: $e');
      // Handle error here
    }
  }

  Future<void> fetchSolidsRecords(SolidsProvider solidsProvider) async {
    try {
      List<SolidsData> record = await solidsProvider.getSolidsRecords();
      print('Fetched solids Records: $record');
      setState(() {
        solidsRecords = record;
        print('Fetched solids Records: $record');
      });
    } catch (e) {
      print('Error fetching solids records: $e');
      // Handle error here
    }
  }

  Future<void> fetchBottleData(BottleDataProvider bottleDataProvider) async {
    try {
      List<BottleData> record = await bottleDataProvider.getBottleRecords();
      print('Fetched bottle Records: $record');
      setState(() {
        bottleRecords = record;
        print('Fetched bottle Records: $record');
      });
    } catch (e) {
      print('Error fetching bottle records: $e');
      // Handle error here
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
    startWeekUpdateTimer();
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    fetchMedicationRecords(diaperProvider);
    sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    fetchSleepRecords(sleepProvider);
    solidsProvider = Provider.of<SolidsProvider>(context, listen: false);
    fetchSolidsRecords(solidsProvider);
    bottleDataProvider =
        Provider.of<BottleDataProvider>(context, listen: false);
    fetchBottleData(bottleDataProvider);
  }

  loadDataFromSharedPreferences() async {
    sharedPref = await SharedPreferences.getInstance();
    dateOfBirthString = sharedPref.getString('date_of_birth') ?? '';
    if (dateOfBirthString.isEmpty) {
      dateOfBirthString = '2012-11-13';
      await sharedPref.setString('date_of_birth', dateOfBirthString);
    }
    setState(() {
      firstName = sharedPref.getString('first_name') ?? '';
      babyname = sharedPref.getString('baby_name') ?? '';
      print('Date of Birth String: $dateOfBirthString');
      calculateWeeks(); // Calculate weeks initially after setting the dateOfBirthString
    });
  }

  void calculateWeeks() {
    // Calculate weeks from dateOfBirthString and assign it to weekText
    weekText = calculateAgeInWeeks(dateOfBirthString);
    setState(() {});
  }

  String calculateAgeInWeeks(String dobString) {
    // Parse the date of birth string to a DateTime object
    DateTime dob = DateTime.parse(dobString);

    // Calculate the difference between the current date and the birth date
    Duration difference = DateTime.now().difference(dob);

    // Calculate the age in weeks (considering 7 days per week)
    int weeks = difference.inDays ~/ 7;

    return ' $weeks weeks'; // Return the age in weeks as a string
  }

  void startWeekUpdateTimer() {
    const oneWeek = const Duration(days: 7); // Update every week
    Timer.periodic(oneWeek, (Timer timer) {
      // Call calculateWeeks every week to update the displayed age
      calculateWeeks();
    });
  }

  String getGreeting() {
    var now = DateTime.now();
    var currentTime = now.hour;

    // Morning is considered until 12 PM (noon)
    if (currentTime < 12) {
      return 'Good morning';
    } else {
      // If not morning, consider it as evening
      return 'Good evening';
    }
  }

  List todaySleepArr = [
    {
      "name": "Sleep",
      "image": "assets/images/sleep_yellow.png",
    },
    {
      "name": "Diapers",
      "image": "assets/images/diaper_blue.png",
    },
    {
      "name": "Feed",
      "image": "assets/images/blue_bottle.png",
    },
  ];

  List activiteslist = [
    {
      "activityname": "Sleep",
      "subtitle": "last sleep",
      "image": "assets/images/sleep_act.png"
    },
    {
      "activityname": "Feed",
      "subtitle": "last feed",
      "image": "assets/images/baby_bottl2.png"
    },
    {
      "activityname": "Diaper",
      "subtitle": "last change",
      "image": "assets/images/diaper_change.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(color: Tcolor.gray, fontSize: 14),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/notification-icon.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: media.height * 0.2,
                  //color: Tcolor.black,
                  child: LayoutBuilder(builder: (context, constraints) {
                    double innerHeight = constraints.maxHeight;
                    double innerWidth = constraints.maxWidth;
                    return Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Container(
                            height: innerHeight * 0.80,
                            width: innerWidth,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: Tcolor.primaryG),
                              borderRadius:
                                  BorderRadius.circular(media.width * 0.07),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/dots_lighter.png",
                                    height: media.width * 0.4,
                                    width: double.maxFinite,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: 20,
                                  child: Text(
                                    weekText,
                                    style: TextStyle(
                                        color: Tcolor.black, fontSize: 15),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  top: 40,
                                  //bottom: 25,
                                  child: Text(
                                    "${getGreeting()} $babyname & $firstName",
                                    style: TextStyle(
                                        color: Tcolor.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            minRadius: 20,
                            maxRadius: 20,
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/profile.png",
                                width: innerWidth * 0.16,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 59,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            minRadius: 15,
                            maxRadius: 15,
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/profile.png",
                                width: innerWidth * 0.16,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Last 24 hours',
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.5,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: activiteslist.length,
                      itemBuilder: (context, index) {
                        var aobj = activiteslist[index] as Map? ?? {};
                        Widget pageRoute;
                        switch (index) {
                          case 0:
                            pageRoute = SleepingView();
                            break;
                          case 1:
                            pageRoute = FeedingView();
                            break;
                          case 2:
                            pageRoute = DiaperChange();
                            break;
                          default:
                            pageRoute = Container();
                            break;
                        }
                        return Activites(
                            aobj: aobj,
                            index: index,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pageRoute),
                              );
                            });
                      }),
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Recently Activity',
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todaySleepArr.length,
                  itemBuilder: (context, index) {
                    if (todaySleepArr[index] is Map<String, dynamic>) {
                      Map<String, dynamic> sObj = todaySleepArr[index];

                      if (sObj.isNotEmpty) {
                        return TodaySleepScheduleRow(
                          activityData: sObj,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
