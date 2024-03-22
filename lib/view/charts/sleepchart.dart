import 'package:baby_tracker/models/sleepData.dart';
import 'package:flutter/material.dart';

class SleepHeatmap extends StatelessWidget {
  final List<SleepData> sleepData;

  const SleepHeatmap({Key? key, required this.sleepData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> dateTitles = _getDateTitles();

    return Column(
      children: [
        // Top titles representing the last seven days
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dateTitles.map((date) {
            return _buildDateTitle(date);
          }).toList(),
        ),
        // Left title and GridView.builder (your existing code)
        Row(
          children: [
            // Left title
            Container(
              width: 40, // Adjust width as needed
              child: Column(
                children: [
                  _buildHourTitle('00:00'),
                  _buildHourTitle('06:00'),
                  _buildHourTitle('12:00'),
                  _buildHourTitle('18:00'),
                  _buildHourTitle('00:00'),
                ],
              ),
            ),
            // GridView.builder
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 columns for days of the week
                  crossAxisSpacing: 3.5,
                  mainAxisSpacing: 3.5,
                  childAspectRatio: 3.5,
                ),
                itemCount: 24 * 7, // 24 rows for each hour of the day
                itemBuilder: (BuildContext context, int index) {
                  final int day = index % 7;
                  final int hour = index ~/ 7;
                  final DateTime currentDate =
                      DateTime.now().subtract(Duration(days: 6 - day));
                  int totalSleepMinutes = 0;
                  int totalMinutesInHour = 60;

                  // Calculate the start and end time for the current hour
                  final DateTime hourStart = DateTime(currentDate.year,
                      currentDate.month, currentDate.day, hour);
                  final DateTime hourEnd = hourStart.add(Duration(hours: 1));

                  // Calculate the total sleep minutes within the current hour
                  sleepData.forEach((sleep) {
                    final DateTime? sleepStart = sleep.startDate;
                    final DateTime? sleepEnd = sleep.endDate;

                    if (sleepStart != null && sleepEnd != null) {
                      // Check if there's an overlap between the sleep record and the current hour
                      if (sleepStart.isBefore(hourEnd) &&
                          sleepEnd.isAfter(hourStart)) {
                        final DateTime overlapStart =
                            sleepStart.isAfter(hourStart)
                                ? sleepStart
                                : hourStart;
                        final DateTime overlapEnd =
                            sleepEnd.isBefore(hourEnd) ? sleepEnd : hourEnd;
                        final int overlapMinutes =
                            overlapEnd.difference(overlapStart).inMinutes;
                        totalSleepMinutes += overlapMinutes;
                      }
                    }
                  });

                  // Calculate the proportion of minutes slept in the current hour
                  double proportion = totalSleepMinutes / totalMinutesInHour;

                  return Container(
                    color: _getColorForSleepMinutes(proportion),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _getDateTitles() {
    List<String> titles = [];
    final currentDate = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      DateTime date = currentDate.subtract(Duration(days: i));
      String dateStr = '${date.day}.${date.month}';
      titles.add(dateStr);
    }
    return titles;
  }

  Widget _buildDateTitle(String date) {
    return Container(
      height: 20, // Adjust height as needed
      alignment: Alignment.center,
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }

  Widget _buildHourTitle(String hour) {
    return Container(
      height: 80, // Adjust height as needed
      alignment: Alignment.center,
      child: Text(
        hour,
        style: TextStyle(color: Colors.black, fontSize: 11),
      ),
    );
  }

  Color _getColorForSleepMinutes(double proportion) {
    if (proportion > 0) {
      return Colors.green;
    } else if (proportion > 3) {
      return Colors.yellow;
    } else {
      return Colors.grey.shade300;
    }
  }
}
