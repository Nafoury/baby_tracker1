import 'package:baba_tracker/view/more/activitydetails.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/view/more/ActivityItem.dart';
import 'package:baba_tracker/common/color_extension.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  int selectedButtonIndex = 0;
  List<String> buttonNames = [
    "Baby Care",
    "Bottle Feeding",
    "Crying",
    "Mild Illnesses",
    "Sleeping",
    "Feeding",
    "Mental Health"
  ];

  List<List<List<ActivityItem>>> subtitleLists = [
    // Baby Care
    [
      [
        ActivityItem(
          subtitle: "Babycare basics",
          imageUrl: "assets/images/mum_handle.jpeg",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "changing your baby's diaper",
          imageUrl: "assets/images/diaper.jpg",
          relatedArticle: "Learn How to Change a Diaper",
        ),
        ActivityItem(
          subtitle: "Burbing",
          imageUrl: "assets/images/baby_buring.jpg",
          relatedArticle: "Best burping positions",
        ),
        ActivityItem(
          subtitle: "What is cradle cap?",
          imageUrl: "assets/images/cardle_cap1.png",
          relatedArticle: "What Is Cradle Cap?",
        ),
        ActivityItem(
          subtitle: "Bathing your newborn",
          imageUrl: "assets/images/bathing.gif",
          relatedArticle: "When to bath newborns",
        ),
      ],
    ],
    // Bottle Feeding
    [
      [
        ActivityItem(
          subtitle: "Choosing the best baby bottles and nipples",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How to Choose Bottles and Nipples",
        ),
        ActivityItem(
          subtitle: "9 simple tips for bottle feeding",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How to bottle feed your baby",
        ),
        ActivityItem(
          subtitle: "Is your baby a slow or a fast feeder?",
          imageUrl: "assets/images/burbing.png",
          relatedArticle: "How Long Should Bottle-Feeding Take?",
        ),
        ActivityItem(
          subtitle: "How much milk does my baby need?",
          imageUrl: "assets/images/cradle_cap.png",
          relatedArticle: "How Much Should My Baby Eat?",
        ),
      ],
    ],

    [
      [
        ActivityItem(
          subtitle: "Baby led or routin led?",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "How much crying is normal?",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "How to soothe a crying baby",
          imageUrl: "assets/images/burbing.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "coping with crying",
          imageUrl: "assets/images/cradle_cap.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "Your baby's first fever",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Ear infections: what you need to know",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Dealing with diarrhea",
          imageUrl: "assets/images/burbing.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "coping with colic",
          imageUrl: "assets/images/cradle_cap.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "Developing a consistent sleep routine",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "How much sleep does my baby need?",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "when will my baby sleep through the night?",
          imageUrl: "assets/images/burbing.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Establishing good sleep habits",
          imageUrl: "assets/images/cradle_cap.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "How do I know my baby is getting enough?",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "when do I feed my baby?",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "4 tips for breastfeedin in public",
          imageUrl: "assets/images/burbing.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
      ],
    ],
    [
      [
        ActivityItem(
          subtitle: "Top tips for the first 6 weeks",
          imageUrl: "assets/images/baby_care.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "coping with new parent stress",
          imageUrl: "assets/images/sleep_act.png",
          relatedArticle: "How Do I Handle My Baby?",
        ),
        ActivityItem(
          subtitle: "Postpartum depression explained",
          imageUrl: "assets/images/burbing.png",
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
                    "Guides",
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
                                (MediaQuery.of(context).size.width * 0.3) - 30,
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
        return Alignment.centerLeft + const Alignment(0.32, 0);
      case 2:
        return Alignment.centerLeft + const Alignment(0.65, 0);
      case 3:
        return Alignment.center;
      case 4:
        return Alignment.centerRight - const Alignment(0.7, 0);
      case 5:
        return Alignment.centerRight - const Alignment(0.3, 0);
      case 6:
        return Alignment.centerRight;

      default:
        return Alignment.centerLeft;
    }
  }
}
