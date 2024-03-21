import 'package:flutter/foundation.dart';
import 'package:baby_tracker/models/sleepData.dart';

import 'package:baby_tracker/controller/sleepcontroller.dart';

class SleepProvider extends ChangeNotifier {
  late SleepController sleepController;

  SleepProvider() {
    sleepController = SleepController();
  }
  List<SleepData> _sleepRecords = List<SleepData>.empty(growable: true);
  List<SleepData> get sleepRecords => _sleepRecords;

  Future addSleepData(SleepData sleepData) async {
    print('Adding medication record: $sleepData');
    final bool res = await sleepController.saveSleepData(sleepData: sleepData);
    if (res) {
      _sleepRecords.add(sleepData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_sleepRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<SleepData>> getSleepRecords() async {
    try {
      final List<SleepData> res = await sleepController.retrievesleepData();
      _sleepRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_sleepRecords');
      return _sleepRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editSleepRecord(SleepData sleepData) async {
    final bool res = await sleepController.editRecord(sleepData);
    if (res) {
      final int index = _sleepRecords
          .indexWhere((element) => element.sleepId == sleepData.sleepId);
      _sleepRecords[index] = sleepData;
      notifyListeners();
    }
  }

  Future deleteDiaperRecord(int sleepId) async {
    final bool res = await sleepController.deleteRecord(sleepId);
    if (res) {
      _sleepRecords.removeWhere((element) => element.sleepId == sleepId);
      notifyListeners();
    }
  }
}
