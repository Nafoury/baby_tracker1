import 'package:baby_tracker/controller/sleepcontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SleepDataProvider extends ChangeNotifier {
  late SharedPreferences sharedPref;

  List<SleepData> _sleepRecords = List<SleepData>.empty(growable: true);
  List<SleepData> get sleepRecords => _sleepRecords;

  Future getSleepRecords() async {
    List<SleepData> res = await SleepController().retrievesleepData();
    _sleepRecords = res;
    notifyListeners();
  }

  Future addSleepRecord(SleepData sleepData) async {
    bool res = await SleepController().saveSleepData(sleepData: sleepData);
    if (res) {
      await getSleepRecords();
    }
  }

  Future editSleepRecord() async {
    // bool res = await SleepController().editSleepData(sleepData: sleepData);
    // if (res) {
    //   await getSleepRecords();
    // }
  }
  Future deleteSleepRecord() async {
    // bool res = await SleepController().deleteSleepData(sleepData: sleepData);
    // if (res) {
    //   await getSleepRecords();
    // }
  }

/*
  SleepDataProvider() {
    initSharedPreferences(); // Call init function in constructor or wherever appropriate
  }

  void initSharedPreferences() async {
    sharedPref = await SharedPreferences.getInstance();
    _sleepRecords = loadSleepDataFromPrefs(); // Load data on initialization
    notifyListeners();
  }

  void saveSleepDataToPrefs(List<SleepData> sleepRecords) {
    List<Map<String, dynamic>> sleepDataJsonList =
        sleepRecords.map((sleepData) => sleepData.toJson()).toList();

    sharedPref.setStringList(
        'sleepRecords', sleepDataJsonList.map((e) => json.encode(e)).toList());
  }

  Future<void> printSleepRecordsFromSharedPreferences() async {
    List<String>? sleepRecordsString = sharedPref.getStringList('sleepRecords');
    if (sleepRecordsString != null) {
      print('Stored sleep records in SharedPreferences:');
      sleepRecordsString.forEach((record) => print(record));
    } else {
      print('No sleep records found in SharedPreferences.');
    }
  }

  List<SleepData> loadSleepDataFromPrefs() {
    List<String>? sleepDataJsonList = sharedPref.getStringList('sleepRecords');
    if (sleepDataJsonList == null) {
      return [];
    }

    try {
      return sleepDataJsonList
          .map((jsonString) => SleepData.fromJson(json.decode(jsonString)))
          .toList();
    } catch (e) {
      print('Error loading sleep records: $e');
      print('Problematic JSON data: $sleepDataJsonList');
      return [];
    }
  }

  void addOrUpdateSleepRecord(SleepData sleepData) {
    try {
      
      int existingIndex = _sleepRecords.indexWhere((record) =>
          record.startDate.year == sleepData.startDate.year &&
          record.startDate.month == sleepData.startDate.month &&
          record.startDate.day == sleepData.startDate.day);

      if (existingIndex != -1) {
        // Update existing record
        Duration updatedDuration =
            sleepData.endDate.difference(sleepData.startDate);
        _sleepRecords[existingIndex] = SleepData(
          startDate: _sleepRecords[existingIndex].startDate,
          endDate: _sleepRecords[existingIndex].endDate.add(updatedDuration),
          id: sleepData.id,
        );
      } else {
        // Add a new sleep record
        _sleepRecords.add(sleepData);
      }

      notifyListeners(); // Notify listeners of the change in sleep records

      saveSleepDataToPrefs(_sleepRecords); // Save records after any update
      printSleepRecordsFromSharedPreferences(); // Optionally, print the updated records
    } catch (e) {
      print('Error adding/updating sleep record: $e');
    }
  }

  List<SleepData> get sleepRecords => _sleepRecords;

  SleepData? getLastAddedSleepRecord() {
    if (_sleepRecords.isNotEmpty) {
      return _sleepRecords.last;
    } else {
      return null;
    }
  }
  */
}
