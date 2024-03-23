import 'package:baby_tracker/controller/feedingBottle.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:flutter/material.dart';

class BottleDataProvider extends ChangeNotifier {
  late BottleController bottleController;

  BottleDataProvider() {
    bottleController = BottleController();
  }
  List<BottleData> _bottleRecords = List<BottleData>.empty(growable: true);
  List<BottleData> get bottleRecords => _bottleRecords;

  Future addBottleData(BottleData bottleData) async {
    print('Adding medication record: $bottleData');
    final bool res =
        await bottleController.savebottlerData(bottleData: bottleData);
    if (res) {
      _bottleRecords.add(bottleData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_bottleRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<BottleData>> getBottleRecords() async {
    try {
      final List<BottleData> res = await bottleController.retrieveBottleData();
      _bottleRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_bottleRecords');
      return _bottleRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editBottlerRecord(BottleData bottleData) async {
    final bool res = await bottleController.editRecord(bottleData);
    if (res) {
      final int index = _bottleRecords
          .indexWhere((element) => element.feed1Id == bottleData.feed1Id);
      _bottleRecords[index] = bottleData;
      notifyListeners();
    }
  }

  Future deleteBottleRecord(int bottleId) async {
    final bool res = await bottleController.deleteRecord(bottleId);
    if (res) {
      _bottleRecords.removeWhere((element) => element.feed1Id == bottleId);
      notifyListeners();
    }
  }
}
