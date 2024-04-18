import 'package:baby_tracker/view/more/ActivityItem.dart';
import 'package:flutter/material.dart';

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
    "Dad",
    "Sleeping",
    "Feeding",
    "Mental Health"
  ];

  List<List<ActivityItem>> subtitleLists = [
    [
      ActivityItem(
        subtitle: "Babycare basics",
        imageUrl: "assets/images/sleep_act.png",
      ),
      ActivityItem(
        subtitle: "changing your baby's diaper",
        imageUrl: "assets/images/sleep_act.png",
      ),
      ActivityItem(
        subtitle: "Burbing",
        imageUrl: "assets/images/sleep_act.png",
      ),
      ActivityItem(
        subtitle: "What is cradle cap?",
        imageUrl: "assets/images/sleep_act.png",
      ),
      ActivityItem(
        subtitle: "changing your baby's diaper",
        imageUrl: "assets/images/sleep_act.png",
      ),
      ActivityItem(
        subtitle: "Bathing your newborn",
        imageUrl: "assets/images/sleep_act.png",
      ),
    ], // Baby Care

    // Add subtitle lists for other buttons here
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
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
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.green],
                              ),
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
                    .map((activity) => _buildSubtitleBox(activity))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleBox(ActivityItem activity) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
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
          Text(
            activity.subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Alignment _calculateAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.centerLeft + const Alignment(0.7, 0);
      case 2:
        return Alignment.centerRight - const Alignment(0.7, 0);
      case 3:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}
