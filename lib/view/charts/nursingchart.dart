import 'package:baba_tracker/models/nursingData.dart';
import 'package:flutter/material.dart';

class NursingHeatmap extends StatefulWidget {
  final List<NusringData> nursingData;

  const NursingHeatmap({Key? key, required this.nursingData}) : super(key: key);

  @override
  _NursingHeatmapState createState() => _NursingHeatmapState();
}

class _NursingHeatmapState extends State<NursingHeatmap> {
  DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final List<String> dateTitles = _getDateTitles(_startDate);

    return Column(
      children: [
        // Top titles representing the last seven days

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _startDate = _startDate.subtract(Duration(days: 7));
                });
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () {
                setState(() {
                  _startDate = _startDate.add(Duration(days: 7));
                });
              },
              icon: Icon(
                Icons.arrow_forward,
                size: 20,
              ),
            ),
          ],
        ),
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
                  crossAxisCount: 7,
                  crossAxisSpacing: 3.5,
                  mainAxisSpacing: 3.5,
                  childAspectRatio: 3.5,
                ),
                itemCount: 24 * 7, 
                itemBuilder: (BuildContext context, int index) {
                  final int day = index % 7;
                  final int hour = index ~/ 7;
                  final DateTime currentDate =
                      _startDate.subtract(Duration(days: 6 - day));
                  int totalSleepMinutes = 0;
                  int totalMinutesInHour = 60;
                  bool hasSleepData = false;

                  // Calculate the start and end time for the current hour
                  final DateTime hourStart = DateTime(currentDate.year,
                      currentDate.month, currentDate.day, hour);
                  final DateTime hourEnd = hourStart.add(Duration(hours: 1));

                  // Check if there is sleep data for the current hour
                  for (var sleep in widget.nursingData) {
                    final DateTime? sleepStart = sleep.date;
                    final Duration? leftDuration = sleep.leftDuration != null
                        ? _parseDuration(sleep.leftDuration!)
                        : null;
                    final Duration? rightDuration = sleep.rightDuration != null
                        ? _parseDuration(sleep.rightDuration!)
                        : null;

                    if (sleepStart != null &&
                        leftDuration != null &&
                        rightDuration != null) {
                      final DateTime sleepEnd =
                          sleepStart.add(leftDuration + rightDuration);
                      if (sleepStart.isBefore(hourEnd) &&
                          sleepEnd.isAfter(hourStart)) {
                        hasSleepData = true;
                        break;
                      }
                    }
                  }

                  if (!hasSleepData) {
                    return Container(
                      color: Colors.grey.shade300,
                    );
                  }

                  // Calculate the total sleep minutes within the current hour(each record (session) )
                  widget.nursingData.forEach((sleep) {
                    final DateTime? sleepStart = sleep.date;
                    final Duration? leftDuration = sleep.leftDuration != null
                        ? _parseDuration(sleep.leftDuration!)
                        : null;
                    final Duration? rightDuration = sleep.rightDuration != null
                        ? _parseDuration(sleep.rightDuration!)
                        : null;
                    if (sleepStart != null &&
                        leftDuration != null &&
                        rightDuration != null) {
                      // Check if there's an overlap between the sleep record and the current hour
                      final DateTime sleepEnd =
                          sleepStart.add(leftDuration + rightDuration);
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

                  return FractionallySizedBox(
                    heightFactor: proportion,
                    child: Container(
                      color: _getColorForSleepMinutes(proportion),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<String> _getDateTitles(DateTime startDate) {
    List<String> titles = [];
    final currentDate = startDate;
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
    if (proportion >= 1.0) {
      return Colors.green.shade300; // Entire hour slept
    } else if (proportion > 0.75) {
      return Colors.lightGreen; // More than 45 minutes slept
    } else if (proportion > 0.5) {
      return Colors.yellow; // More than 30 minutes slept
    } else if (proportion > 0.25) {
      return Colors.orange; // More than 15 minutes slept
    } else if (proportion > 0) {
      return Colors.red.shade300; // Less than 15 minutes slept
    } else {
      return Colors.black; // No sleep during this hour
    }
  }

  Duration _parseDuration(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
