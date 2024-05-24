import 'package:baba_tracker/controller/diapercontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:baba_tracker/models/diaperData.dart';

class DiaperProvider extends ChangeNotifier {
  late DiaperController diaperController;

  DiaperProvider() {
    diaperController = DiaperController();
  }
  List<DiaperData> _diaperRecords = List<DiaperData>.empty(growable: true);
  List<DiaperData> get diaperRecords => _diaperRecords;

  Future addDiaperData(DiaperData diaperData) async {
    print('Adding medication record: $diaperData');
    final bool res =
        await diaperController.saveDiaperData(diaperData: diaperData);
    if (res) {
      _diaperRecords.add(diaperData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_diaperRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<DiaperData>> getMedicationRecords() async {
    try {
      final List<DiaperData> res = await diaperController.retrieveDiaperData();
      _diaperRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_diaperRecords');
      return _diaperRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editDiaperRecord(DiaperData diaperData) async {
    final bool res = await diaperController.editDiaper(diaperData);
    if (res) {
      final int index = _diaperRecords
          .indexWhere((element) => element.changeId == diaperData.changeId);
      _diaperRecords[index] = diaperData;
      notifyListeners();
    }
  }

  Future deleteDiaperRecord(int changeId) async {
    final bool res = await diaperController.deleteDiaper(changeId);
    if (res) {
      _diaperRecords.removeWhere((element) => element.changeId == changeId);
      notifyListeners();
    }
  }
}
