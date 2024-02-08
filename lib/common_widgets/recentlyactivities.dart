import 'package:flutter/material.dart';
import 'package:baby_tracker/common/color_extension.dart';

class TodaySleepScheduleRow extends StatelessWidget {
  final Map<String, dynamic> activityData;

  const TodaySleepScheduleRow({Key? key, required this.activityData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch the duration dynamically from activityData
    String activityDuration = activityData["duration"].toString();

    // Widget for displaying the duration
    Widget durationWidget = Text(
      " $activityDuration",
      style: TextStyle(
        color: Tcolor.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Tcolor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              activityData["image"].toString(),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display duration at the start
                durationWidget,
                const SizedBox(height: 4),
                // Display the name of the activity
                Text(
                  activityData["name"].toString(),
                  style: TextStyle(
                    color: Tcolor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                _buildActivityDetails(
                    activityData), // Display activity-specific details
              ],
            ),
          ),
          SizedBox(
            height: 35,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/images/more_vertical3.png",
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDetails(Map<String, dynamic> data) {
    // Additional details based on activity type
    if (data["name"] == "Sleep") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start: ${data["HH:mm"]}", //showing the hours am or pm
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "End: ${data["HH:mm"]}", //showing the hours am or pm
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Duration: ${data["duration"]} minutes", //here calculating the duration between strat and end date
            style: TextStyle(
              color: Tcolor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (data["name"] == "Diapers") {
      return Text(
        "Status: ${data["status"]}",
        style: TextStyle(
          color: Tcolor.gray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (data["name"] == "Feed") {
      return Text(
        "Type: ${data["feedingType"]}",
        style: TextStyle(
          color: Tcolor.gray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // Return an empty widget if the activity type is not recognized
    return SizedBox();
  }
}
