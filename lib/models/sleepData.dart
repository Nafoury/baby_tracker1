import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class SleepData {
  int? sleepId;
  DateTime? startDate;
  DateTime? endDate;
  int? duration;
  String? note;
  int? babyId;

  SleepData(
      {this.sleepId,
      this.startDate,
      this.endDate,
      this.duration,
      this.note,
      this.babyId});

  SleepData.fromJson(Map<String, dynamic> json) {
    sleepId = json['sleep_id'];
    startDate = DateTime.parse(json['start_date']);
    endDate = DateTime.parse(json['end_date']);
    duration = json['duration'];
    note = json['note'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sleep_id'] = this.sleepId;
    data['start_date'] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(this.startDate!);
    data['end_date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(this.endDate!);
    data['duration'] = this.duration;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
