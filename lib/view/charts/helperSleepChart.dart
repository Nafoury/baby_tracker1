import 'package:flutter/material.dart';

class SleepDuration {
  final DateTime startTime;
  final DateTime endTime;

  SleepDuration({required this.startTime, required this.endTime});

  double proportionOfSleepWithinHour(DateTime hourStart, DateTime hourEnd) {
    // Check if there's an overlap between the sleep record and the current hour
    DateTime overlapStart =
        startTime.isAfter(hourStart) ? startTime : hourStart;
    DateTime overlapEnd = endTime.isBefore(hourEnd) ? endTime : hourEnd;
    int overlapMinutes = overlapEnd.difference(overlapStart).inMinutes;
    return overlapMinutes / 60.0; // Return proportion of sleep within the hour
  }
}
