import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// SleepData model
class SleepData {
  final DateTime startDate;
  final DateTime endDate;
  final String id;

  SleepData({
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  factory SleepData.fromJson(Map<String, dynamic>? json) {
    if (json == null ||
        json['start_date'] == null ||
        json['end_date'] == null ||
        json['id'] == null) {
      return SleepData(
          startDate: DateTime.now(), endDate: DateTime.now(), id: '');
    }

    try {
      final startDate = DateTime.parse(json['start_date']);
      final endDate = DateTime.parse(json['end_date']);

      if (startDate != null && endDate != null) {
        return SleepData(
          startDate: startDate,
          endDate: endDate,
          id: json['id'],
        );
      } else {
        throw FormatException('Date parsing error');
      }
    } catch (e) {
      print('Error parsing dates: $e');
      print('Problematic JSON data: $json');
      return SleepData(
          startDate: DateTime.now(), endDate: DateTime.now(), id: '');
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'start_date': DateFormat('yyyy-MM-dd HH:mm').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd HH:mm').format(endDate),
      'id': id,
    };
  }
}
