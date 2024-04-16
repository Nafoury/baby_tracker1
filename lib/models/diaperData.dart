import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DiaperData {
  int? changeId;
  final DateTime startDate;
  final String status;
  final String note;
  final int? infoid;

  DiaperData({
    this.changeId,
    required this.startDate,
    required this.note,
    required this.status,
    this.infoid,
  });
  DiaperData.fromMap(Map<String, dynamic> map)
      : changeId = map['change_id'],
        startDate = DateTime.parse(map['start_date']),
        status = map['status'],
        note = map['note'],
        infoid = map['baby_id'];

  // Method to convert to a map
  Map<String, dynamic> toMap() {
    return {
      'change_id': changeId,
      'start_date': startDate.toIso8601String(),
      'status': status,
      'note': note,
      'baby_id': infoid,
    };
  }
}
