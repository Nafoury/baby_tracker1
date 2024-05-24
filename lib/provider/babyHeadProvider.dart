import 'package:baba_tracker/controller/babyHeadController.dart';
import 'package:baba_tracker/models/babyHead.dart';
import 'package:flutter/foundation.dart';

class HeadMeasureProvider extends ChangeNotifier {
  late HeadMeasureController headMeasureController;

  HeadMeasureProvider() {
    headMeasureController = HeadMeasureController();
  }
  List<MeasureData> _headRecords = List<MeasureData>.empty(growable: true);
  List<MeasureData> get headRecords => _headRecords;

  Future addHeadData(MeasureData measureData) async {
    print('Adding measure head record: $measureData');
    final bool res =
        await headMeasureController.saveMeasureData(measureData: measureData);
    if (res) {
      _headRecords.add(measureData); // Corrected variable name
      notifyListeners();
      print('head record added successfully: $_headRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<MeasureData>> getMeasureRecords() async {
    try {
      final List<MeasureData> res =
          await headMeasureController.retrieveHeadData();
      _headRecords = res;
      notifyListeners();
      print('Retrieved head measure records: $_headRecords');
      return _headRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving head records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editHeadRecord(MeasureData measureData) async {
    final bool res = await headMeasureController.edithead(measureData);
    if (res) {
      final int index = _headRecords
          .indexWhere((element) => element.measureId == measureData.measureId);
      _headRecords[index] = measureData;
      notifyListeners();
    }
  }

  Future deleteHeadRecord(int measureId) async {
    final bool res = await headMeasureController.deleteWeight(measureId);
    if (res) {
      _headRecords.removeWhere((element) => element.measureId == measureId);
      notifyListeners();
    }
  }
}
