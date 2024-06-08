import 'package:baba_tracker/Services/notifi_service.dart';
import 'package:baba_tracker/Services/workManager.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/activites.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/models/ImageModel.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/models/medData.dart';
import 'package:baba_tracker/models/vaccineData.dart';
import 'package:baba_tracker/provider/UserImageProvider.dart';
import 'package:baba_tracker/provider/medications_provider.dart';
import 'package:baba_tracker/provider/tempProvider.dart';
import 'package:baba_tracker/provider/vaccine_provider.dart';
import 'package:baba_tracker/view/profiles/children_profile.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/models/solidsData.dart';
import 'package:baba_tracker/models/tempData.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/bottleDataProvider.dart';
import 'package:baba_tracker/provider/diaper_provider.dart';
import 'package:baba_tracker/provider/nursingDataProvider.dart';
import 'package:baba_tracker/provider/sleep_provider.dart';
import 'package:baba_tracker/provider/solids_provider.dart';
import 'package:baba_tracker/view/editionanddeletion/bottleData_edit_deletion.dart';
import 'package:baba_tracker/view/editionanddeletion/diaper_edit.dart';
import 'package:baba_tracker/view/editionanddeletion/nursing_edition_deletion.dart';
import 'package:baba_tracker/view/editionanddeletion/sleep_edit.dart';
import 'package:baba_tracker/view/editionanddeletion/solids_editon_deletion.dart';
import 'package:baba_tracker/view/home/diaper_change.dart';
import 'package:baba_tracker/view/home/feeding_view.dart';
import 'package:baba_tracker/view/home/sleeping_view.dart';
import 'package:baba_tracker/view/main_tab/main_tab.dart';
import 'package:baba_tracker/view/profiles/mom_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:baba_tracker/common_widgets/recentlyactivities.dart';

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
  late List<SolidsData> solidsRecords = [];
  late List<BottleData> bottleRecords = [];
  late List<BabyInfo> babyRecords = [];
  late List<TempData> tempRecords = [];
  late List<SleepData> sleepRecords = [];
  late List<NusringData> nursingRecords = [];
  BabyInfo babyInfo = BabyInfo();
  late DiaperProvider diaperProvider;
  late BabyProvider babyProvider;
  late SleepProvider sleepProvider;
  late SolidsProvider solidsProvider;
  late BottleDataProvider bottleDataProvider;
  late NursingDataProvider nursingDataProvider;
  late UserImageProvider userImageProvider;
  late MedicationsProvider medicationsProvider;
  late VaccineProvider vaccineProvider;
  List<UserData> userimage = [];

  Future<void> fetchImageRecords(UserImageProvider userImageProvider) async {
    try {
      List<UserData> records = await userImageProvider.getImageRecord();
      print('Fetched Image Record: $records');
      setState(() {
        userimage = records;
        print('Fetched diapers Records: $records');
      });
    } catch (e) {
      print('Error fetching diapers records: $e');
      // Handle error here
    }
  }

  Future<void> fetchNursingData(NursingDataProvider nursingDataProvider) async {
    try {
      List<NusringData> record = await nursingDataProvider.getNursingRecords();

      print('Fetched baby Records: $record');
      setState(() {
        nursingRecords = record;
        updateNursingBoxes();
        print('Fetched baby Records: $record');
      });
    } catch (e) {
      print('Error fetching baby records: $e');
      // Handle error here
    }
  }

  Future<void> fetchBabyData(BabyProvider babyProvider) async {
    try {
      await babyProvider.fetchAndSetActiveBaby();

      print('Fetched baby Records: ');
      setState(() {
        babyRecords;

        print('Fetched baby Records: ');
      });
    } catch (e) {
      print('Error fetching baby records: $e');
      // Handle error here
    }
  }

  Future<void> fetchTempRecords(TempProvider tempProvider) async {
    try {
      List<TempData> records = await tempProvider.getTempRecords();
      print('Fetched Medication Records: $records');
      setState(() {
        tempRecords = records;
        print('Fetched Medication Records: $records');
      });
    } catch (e) {
      print('Error fetching medication records: $e');
      // Handle error here
    }
  }

  Future<void> fetchDiaperRecords(DiaperProvider diaperProvider) async {
    try {
      List<DiaperData> records = await diaperProvider.getMedicationRecords();
      print('Fetched diapers Records: $records');
      setState(() {
        diapersRecords = records;
        print('Fetched diapers Records: $records');
        updatestatusBoxes();
      });
    } catch (e) {
      print('Error fetching diapers records: $e');
      // Handle error here
    }
  }

  Future<void> fetchSolidsRecords(SolidsProvider solidsProvider) async {
    try {
      List<SolidsData> record = await solidsProvider.getSolidsRecords();
      print('Fetched solids Records: $record');
      setState(() {
        solidsRecords = record;
        updateSolidsBoxes();
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
        updateBottleBoxes();
        print('Fetched bottle Records: $record');
      });
    } catch (e) {
      print('Error fetching bottle records: $e');
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
        updateSleepBoxes();
      });
    } catch (e) {
      print('Error fetching sleep records: $e');
      // Handle error here
    }
  }

  void updatestatusBoxes() {
    if (diapersRecords.isNotEmpty) {
      DiaperData diaperData = diapersRecords.last;

      String status = diaperData.status;
      String dateTimeString = diaperData.startDate.toString();

      // Splitting the date and time parts
      List<String> dateTimeParts = dateTimeString.split(" ");
      String datePart = dateTimeParts[0]; // Date part remains unchanged
      String timePart = dateTimeParts[1]; // Time part to be modified

      String date = DateFormat('dd MMM,hh:mm').format(diaperData.startDate);
      // Splitting the time string by ":" to get hours, minutes, and seconds
      List<String> timeParts = timePart.split(":");
      // Constructing the time string with only hours and minutes
      String modifiedTime = "${timeParts[0]}:${timeParts[1]}";

      // Joining the modified time with the date part
      String updatedDateTimeString = "$date";

      setState(() {
        todaySleepArr[1]["status"] = status;
        todaySleepArr[1]["time"] =
            updatedDateTimeString; // Assigning the updated date and time string
      });
    }
  }

  void updateSleepBoxes() {
    if (sleepRecords.isNotEmpty) {
      SleepData sleepData = sleepRecords.last;

      String startTime =
          sleepData.startDate.toString().split(" ")[1].substring(0, 5);
      String endTime =
          sleepData.endDate.toString().split(" ")[1].substring(0, 5);

      String hoursPart = '';
      String minutesPart = '';

      if (sleepData.duration != null) {
        int totalMinutes = sleepData.duration!;
        int totalHours = totalMinutes ~/ 60;
        int remainingMinutes = totalMinutes % 60;

        if (totalHours > 0) {
          hoursPart = '${totalHours}h';
        }
        if (remainingMinutes > 0) {
          minutesPart = '${remainingMinutes}m';
        }
      }

      String date = DateFormat('dd MMM,hh:mm').format(sleepData.endDate!);

      setState(() {
        if (todaySleepArr.isNotEmpty) {
          todaySleepArr[0]["Start"] = startTime;
          todaySleepArr[0]["End"] = endTime;
          todaySleepArr[0]["duration"] = '$hoursPart $minutesPart';
          todaySleepArr[0]["time"] = date;
        }
      });
    }
  }

  void updateSolidsBoxes() {
    if (solidsRecords.isNotEmpty) {
      SolidsData solidsData = solidsRecords.last;

      int grains = solidsData.grains!;
      int fruit = solidsData.fruits!;
      int protein = solidsData.protein!;
      int dairy = solidsData.dairy!;
      int veg = solidsData.veg!;

      int total = (grains) + (fruit) + (protein) + (dairy) + (veg);

      String date = DateFormat('dd MMM,hh:mm').format(solidsData.date!);

      setState(() {
        todaySleepArr[2]["time"] = date;
        todaySleepArr[2]["total"] = '$total g';
        todaySleepArr[2]["name"] = "Solids";
      });
    }
  }

  void updateBottleBoxes() {
    if (bottleRecords.isNotEmpty) {
      BottleData bottleData = bottleRecords.last;

      String amount = bottleData.amount!.toString();

      String date = DateFormat('dd MMM,hh:mm').format(bottleData.startDate!);

      setState(() {
        todaySleepArr[3]["time"] = date;
        todaySleepArr[3]["amount"] = '$amount ml';
        todaySleepArr[3]["name"] = "Bottle";
      });
    }
  }

  void updateNursingBoxes() {
    if (nursingRecords.isNotEmpty) {
      NusringData nursingData = nursingRecords.last;
      String date = DateFormat('dd MMM,hh:mm').format(nursingData.date!);
      String startside = nursingData.startingBreast.toString();
      String breastside = nursingData.nursingSide.toString();

      // Parse leftDuration and rightDuration into Duration objects
      Duration leftDuration = nursingData.leftDuration != null
          ? _parseDurationString(nursingData.leftDuration!)
          : Duration.zero;
      Duration rightDuration = nursingData.rightDuration != null
          ? _parseDurationString(nursingData.rightDuration!)
          : Duration.zero;

      // Add the durations together
      Duration totalNursingAmounts = leftDuration + rightDuration;

      // Initialize variables to hold different parts of the duration
      String hoursPart = '';
      String minutesPart = '';
      String secondsPart = '';

      // Check if total duration is less than a minute
      if (totalNursingAmounts.inSeconds < 60) {
        secondsPart = '${totalNursingAmounts.inSeconds}s';
      } else {
        // Check if hours, minutes, or seconds are greater than zero
        if (totalNursingAmounts.inHours > 0) {
          hoursPart = '${totalNursingAmounts.inHours}h';
        }
        if (totalNursingAmounts.inMinutes % 60 > 0) {
          minutesPart = '${totalNursingAmounts.inMinutes % 60}m';
        }
        if (totalNursingAmounts.inSeconds % 60 > 0) {
          secondsPart = '${totalNursingAmounts.inSeconds % 60}s';
        }
      }

      // Concatenate the parts together
      String formattedDuration = '$hoursPart$minutesPart$secondsPart';

      setState(() {
        todaySleepArr[4]["time"] = date;
        todaySleepArr[4]["duration"] = formattedDuration;
        todaySleepArr[4]["side"] = startside;
      });
    }
  }

  Duration _parseDurationString(String durationStr) {
    List<String> parts = durationStr.split(':');
    if (parts.length == 3) {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      return Duration.zero;
    }
  }

  Future<void> _initializeApp() async {
    // Fetch medication records from the server

    List<MedData> medicationRecords =
        await medicationsProvider.getMedicationRecords();

    List<VaccineData> vaccinesRecords =
        await vaccineProvider.getVaccineRecords();

    // Schedule notifications based on the fetched records
    for (var record in medicationRecords) {
      if (record.isReminderSet!) {
        await WorkManagerService().init();
        Duration interval = _parseInterval(record.reminderInterval!);
        await NotificationService.showScheduledNotificationRepeated(
          record.date!,
          interval,
        );
      }
    }
    for (var record in vaccinesRecords) {
      if (record.isReminderSet! && record.date!.isAfter(DateTime.now())) {
        await WorkManagerService().init();
        NotificationService.showSchduledNotification1(
            record.date!, record.type!);
      }
    }
  }

  Duration _parseInterval(String interval) {
    int hours = 0;
    int minutes = 0;
    if (interval.contains('hour')) {
      hours = int.parse(interval.split(' ')[0]);
      if (interval.contains('30 min')) {
        minutes = 30;
      }
    } else if (interval.contains('min')) {
      minutes = int.parse(interval.split(' ')[0]);
    }
    return Duration(hours: hours, minutes: minutes);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    loadDataFromSharedPreferences();
  }

  void fetchData() async {
    // Put all your data fetching logic here
    babyProvider = Provider.of<BabyProvider>(context, listen: false);
    fetchBabyData(babyProvider);
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    fetchDiaperRecords(diaperProvider);
    solidsProvider = Provider.of<SolidsProvider>(context, listen: false);
    fetchSolidsRecords(solidsProvider);
    bottleDataProvider =
        Provider.of<BottleDataProvider>(context, listen: false);
    fetchBottleData(bottleDataProvider);
    sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    fetchSleepRecords(sleepProvider);
    nursingDataProvider =
        Provider.of<NursingDataProvider>(context, listen: false);
    fetchNursingData(nursingDataProvider);
    userImageProvider = Provider.of<UserImageProvider>(context, listen: false);
    fetchImageRecords(userImageProvider);
    medicationsProvider =
        Provider.of<MedicationsProvider>(context, listen: false);
    vaccineProvider = Provider.of<VaccineProvider>(context, listen: false);
    _initializeApp();
  }

  loadDataFromSharedPreferences() async {
    sharedPref = await SharedPreferences.getInstance();
    setState(() {
      firstName = sharedPref.getString('first_name') ?? '';
      // Calculate weeks initially after setting the dateOfBirthString
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
      "name": "Solids",
      "image": "assets/images/blue_bottle.png",
    },
    {
      "name": "Bottle",
      "image": "assets/images/blue_bottle.png",
    },
    {
      "name": "Nursing",
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

  String formatDateDifference(DateTime dateOfBirth) {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);

    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks week${weeks > 1 ? 's' : ''} ';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ';
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Consumer<BabyProvider>(builder: (context, babyProvider, child) {
      if (babyProvider.activeBaby == null) {
        // If activeBaby is null, show loading indicator
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        // Data has been fetched, render the UI with the fetched data
        final activeBaby = babyProvider.activeBaby!.babyName ?? "";
        final image = babyProvider.activeBaby!.image ?? "";
        final dateOfBirthString = babyProvider.activeBaby!.dateOfBirth ?? "";
        final dateOfBirth = DateTime.parse(
            dateOfBirthString.toString()); // Parse the date string
        final formattedDateOfBirth = formatDateDifference(dateOfBirth);
        return Scaffold(
          backgroundColor: Tcolor.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(color: Tcolor.gray, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: media.height * 0.3,
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
                                  gradient:
                                      LinearGradient(colors: Tcolor.primaryG),
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
                                        "$formattedDateOfBirth",
                                        style: TextStyle(
                                            color: Tcolor.black, fontSize: 15),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 47,
                                      //bottom: 25,
                                      child: Text(
                                        "${getGreeting()} $activeBaby & $firstName",
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
                              child: GestureDetector(
                                // Use GestureDetector for interaction
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MomProfile(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: userImageProvider
                                            .userData.first.image!.isNotEmpty
                                        ? Image.network(
                                            "$linkImageFile/${userImageProvider.userData.first.image}",
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                          )
                                        : Image.asset(
                                            "assets/images/profile.png",
                                            fit: BoxFit.cover,
                                            width: 30,
                                            height: 30,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              left: 80,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChildrenProfile(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 25,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: image.isNotEmpty
                                        ? Image.network(
                                            "$linkImageFile/${image}",
                                            fit: BoxFit.cover,
                                            width: 60,
                                            height: 60,
                                          )
                                        : Image.asset(
                                            "assets/images/profile.png",
                                            fit: BoxFit.cover,
                                            width: 20,
                                          ),
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
                      height: media.width * 0.1,
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
                        if (diapersRecords.isNotEmpty &&
                            todaySleepArr[index]["name"] == "Diapers") {
                          return TodaySleepScheduleRow(
                            activityData: todaySleepArr[index],
                            onEdit: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DiaperEdit(
                                          entryData: diapersRecords.last,
                                        )),
                              );
                              fetchDiaperRecords(
                                  diaperProvider); // Re-fetch data after edit
                            },
                            onDelete: () async {
                              await diaperProvider.deleteDiaperRecord(
                                  diapersRecords.last.changeId!);
                              fetchDiaperRecords(
                                  diaperProvider); // Re-fetch data after delete
                            },
                          );
                        }
                        // Check if there are sleep records available
                        if (sleepRecords.isNotEmpty &&
                            todaySleepArr[index]["name"] == "Sleep") {
                          return TodaySleepScheduleRow(
                              activityData: todaySleepArr[index],
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SleepEdit(
                                            entryData: sleepRecords.last,
                                          )),
                                );
                                fetchSleepRecords(sleepProvider);
                              },
                              onDelete: () async {
                                await sleepProvider.deleteSleepRecord(
                                    sleepRecords.last.sleepId!);
                                fetchSleepRecords(sleepProvider);
                              });
                        }

                        if (solidsRecords.isNotEmpty &&
                            todaySleepArr[index]["name"] == "Solids") {
                          return TodaySleepScheduleRow(
                              activityData: todaySleepArr[index],
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SolidsEdit(
                                            entryData: solidsRecords.last,
                                          )),
                                );
                                fetchSolidsRecords(solidsProvider);
                              },
                              onDelete: () async {
                                await solidsProvider.deleteSolidsRecord(
                                    solidsRecords.last.solidId!);
                                fetchSolidsRecords(solidsProvider);
                              });
                        }
                        if (bottleRecords.isNotEmpty &&
                            todaySleepArr[index]["name"] == "Bottle") {
                          return TodaySleepScheduleRow(
                              activityData: todaySleepArr[index],
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottleEdit(
                                            entryData: bottleRecords.last,
                                          )),
                                );
                                fetchBottleData(bottleDataProvider);
                              },
                              onDelete: () async {
                                await bottleDataProvider.deleteBottleRecord(
                                    bottleRecords.last.feed1Id!);
                                fetchBottleData(bottleDataProvider);
                              });
                        }
                        if (nursingRecords.isNotEmpty &&
                            todaySleepArr[index]["name"] == "Nursing") {
                          return TodaySleepScheduleRow(
                              activityData: todaySleepArr[index],
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NursingEditAndDeletion(
                                            entryData: nursingRecords.last,
                                          )),
                                );
                                fetchNursingData(nursingDataProvider);
                              },
                              onDelete: () async {
                                await nursingDataProvider.deleteNursingRecord(
                                    nursingRecords.last.feedId!);
                                fetchNursingData(nursingDataProvider);
                              });
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
