import 'package:baba_tracker/controller/babyHeightController.dart';
import 'package:baba_tracker/models/babyHead.dart';
import 'package:baba_tracker/models/babyHeight.dart';
import 'package:flutter/foundation.dart';

class HeightMeasureProvider extends ChangeNotifier {
  late HeightMeasureController heightMeasureController;

  HeightMeasureProvider() {
    heightMeasureController = HeightMeasureController();
  }
  List<HeightMeasureData> _heightRecords =
      List<HeightMeasureData>.empty(growable: true);
  List<HeightMeasureData> get heightRecords => _heightRecords;

  Future addHeadData(HeightMeasureData heightMeasureData) async {
    print('Adding measure head record: $heightMeasureData');
    final bool res = await heightMeasureController.saveMeasureData(
        heightMeasureData: heightMeasureData);
    if (res) {
      _heightRecords.add(heightMeasureData); // Corrected variable name
      notifyListeners();
      print('head record added successfully: $_heightRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<HeightMeasureData>> getMeasureRecords() async {
    try {
      final List<HeightMeasureData> res =
          await heightMeasureController.retrieveHeadData();
      _heightRecords = res;
      notifyListeners();
      print('Retrieved head measure records: $_heightRecords');
      return _heightRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving head records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editHeightRecord(HeightMeasureData heightMeasureData) async {
    final bool res = await heightMeasureController.edithead(heightMeasureData);
    if (res) {
      final int index = _heightRecords.indexWhere(
          (element) => element.heightId == heightMeasureData.heightId);
      _heightRecords[index] = heightMeasureData;
      notifyListeners();
    }
  }

  Future deleteHeightRecord(int heightid) async {
    final bool res = await heightMeasureController.deleteWeight(heightid);
    if (res) {
      _heightRecords.removeWhere((element) => element.heightId == heightid);
      notifyListeners();
    }
  }
}
