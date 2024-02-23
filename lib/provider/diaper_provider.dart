import 'package:flutter/foundation.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DiaperProvider extends ChangeNotifier {
  late SharedPreferences sharedPref;
  List<DiaperData> _diaperRecords = [];

 
  void addDiaperRecord(DiaperData diaperData) {
    try {
      _diaperRecords.add(diaperData);

      notifyListeners();
     // Notify listeners of the change in sleep records
    } catch (e) {
      print('Error adding diaper record $e');
    }
  }

  List<DiaperData> get diaperRecords => _diaperRecords;
}
