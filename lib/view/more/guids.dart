import 'package:baba_tracker/view/more/activitydetails.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/view/more/ActivityItem.dart';
import 'package:baba_tracker/common/color_extension.dart';

class Guids extends StatefulWidget {
  const Guids({Key? key}) : super(key: key);

  @override
  _GuidsState createState() => _GuidsState();
}

class _GuidsState extends State<Guids> {
  int selectedButtonIndex = 0;
  List<String> buttonNames = [
    "0-6 Months",
    "5-8 Months",
    "9-12 Months",
    "13-18 Months",
    "19-24 Months"
  ];

  List<List<List<ActivityItem>>> subtitleLists = [
    // Baby Care
    [
      [
        ActivityItem(
          subtitle: "play activites for baby's first months",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "6 ways to talk with your baby",
          imageUrl: "assets/images/diaper.jpg",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "early sensory experiences",
          imageUrl: "assets/images/baby_buring.jpg",
          relatedArticle: "Best burping positions",
        ),
      ],
    ],
    // Bottle Feeding
    [
      [
        ActivityItem(
          subtitle: "Ideas for play with your baby",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "3D objects",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],

    [
      [
        ActivityItem(
          subtitle: "Conversation with your baby",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Rolling a ball",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "Using signs",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Getting ready to walk",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Time to read",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "Exploring new activities",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Running around",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Retaining their attention",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(width: 75),
                  Text(
                    "Activites",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: MediaQuery.of(context).size.width * 1.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedContainer(
                          alignment: _calculateAlignment(selectedButtonIndex),
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width:
                                (MediaQuery.of(context).size.width * 0.4) - 50,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: Tcolor.primaryG),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: List.generate(
                              buttonNames.length,
                              (index) => Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedButtonIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      buttonNames[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: selectedButtonIndex == index
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display subtitles for the selected button
              Column(
                children: subtitleLists[selectedButtonIndex]
                    .map((sublist) => Column(
                          children: sublist
                              .map((activity) => _buildSubtitleBox(
                                  activity, selectedButtonIndex))
                              .toList(),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleBox(ActivityItem activities, int sectionIndex) {
    return _buildActivityItem(activities, sectionIndex);
  }

  Widget _buildActivityItem(ActivityItem activity, int sectionIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailPage(
              imageUrl: activity.imageUrl,
              description: activity.subtitle,
              activity: activity,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                activity.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                activity.subtitle,
                style: TextStyle(fontSize: 15, color: Tcolor.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Alignment _calculateAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.centerLeft + const Alignment(0.5, 0);
      case 2:
        return Alignment.center;
      case 3:
        return Alignment.centerRight - const Alignment(0.5, 0);
      case 4:
        return Alignment.centerRight;

      default:
        return Alignment.centerLeft;
    }
  }
}
