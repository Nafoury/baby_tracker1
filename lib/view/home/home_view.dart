import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/activites.dart';
import 'package:baby_tracker/view/home/diaper_change.dart';
import 'package:baby_tracker/view/home/feeding_view.dart';
import 'package:baby_tracker/view/home/sleeping_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:baby_tracker/sqldb.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String weekText = '';
  String babyname = '';
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
    //Future<void> retrieveData() async {
    //SqlDb sqlDb = SqlDb();

    //try {
    //List<Map<String, dynamic>> data = await sqlDb.readData(
    //  'SELECT baby_name, first_name, date_of_birth FROM "complete information" WHERE id = 1');

    //if (data.isNotEmpty) {
    //String babyName = data[0]['baby_name'].toString();
    //String firstName = data[0]['first_name'].toString();
    //String birthDateAsString = data[0]['date_of_birth'].toString();
    //DateTime birthDate = DateTime.parse(birthDateAsString);

    // Calculate the number of weeks since the birth date
    //DateTime currentDate = DateTime.now();
    //int differenceInDays = currentDate.difference(birthDate).inDays;
    //int numberOfWeeks = differenceInDays ~/ 7;

    // Update the text box with the number of weeks
    //setState(() {
    //weekText = '$numberOfWeeks weeks';
    //babyname = 'Welcome $babyName & $firstName';
    //});
    //} else {
    // print('No data found for the specified ID');
    // }
    //} catch (e) {
    // print('Error retrieving data: $e');
    // }
    //}

    //retrieveData();

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
                SizedBox(
                  height: media.width * 0.02,
                ),
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: Tcolor.primaryG),
                    borderRadius: BorderRadius.circular(media.width * 0.075),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/dots_lighter.png",
                        height: media.width * 0.4,
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                      ),
                      Positioned(
                        top: 0,
                        left: 7,
                        child: CircleAvatar(
                          minRadius: 20,
                          maxRadius: 20,
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/images/profile.png",
                              width: 25,
                              height: 25,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 40,
                        child: CircleAvatar(
                          minRadius: 15,
                          maxRadius: 15,
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              "assets/images/profile.png",
                              width: 25,
                              height: 25,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: Text(
                          weekText,
                          style: TextStyle(color: Tcolor.black, fontSize: 15),
                        ),
                      ),
                      Text(
                        babyname,
                        style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
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

                        // Define different page routes for each button
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
                            pageRoute =
                                Container(); // Replace with your default route or an empty container
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
                  height: media.width * 0.02,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
