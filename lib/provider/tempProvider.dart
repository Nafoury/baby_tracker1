import 'package:baby_tracker/controller/tempController.dart';
import 'package:baby_tracker/controller/vaccinecontroller.dart';
import 'package:baby_tracker/models/tempData.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:flutter/foundation.dart';

class TempProvider extends ChangeNotifier {
  late TempController tempController;

  TempProvider() {
    tempController = TempController();
  }

  List<TempData> _tempRecords = []; // Corrected variable name
  List<TempData> get tempRecords => _tempRecords; // Corrected variable name

  Future addTempRecord(TempData tempData) async {
    print('Adding medication record: $tempData');
    final bool res = await tempController.saveTempData(tempData: tempData);
    if (res) {
      _tempRecords.add(tempData); // Corrected variable name
      notifyListeners();
      print('Medication record added successfully: $_tempRecords');
    } else {
      print('Failed to add medication record');
    }
  }

  Future<List<TempData>> getTempRecords() async {
    try {
      final List<TempData> res = await tempController.retrieveTempData();
      _tempRecords = res;
      notifyListeners();
      print('Retrieved vaccine records: $_tempRecords');
      return _tempRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving vaccine records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editTempRecord(TempData tempData) async {
    final bool res = await tempController.editDiaper(tempData);
    if (res) {
      final int index = _tempRecords
          .indexWhere((element) => element.tempId == tempData.tempId);
      _tempRecords[index] = tempData;
      notifyListeners();
    }
  }

  Future deleteTempRecord(int tempId) async {
    final bool res = await tempController.deleteTemp(tempId);
    if (res) {
      _tempRecords.removeWhere((element) => element.tempId == tempId);
      notifyListeners();
    }
  }
}
