import 'package:baba_tracker/controller/teethController.dart';
import 'package:baba_tracker/controller/vaccinecontroller.dart';
import 'package:baba_tracker/models/teethModel.dart';
import 'package:baba_tracker/models/vaccineData.dart';
import 'package:flutter/foundation.dart';

class TeethPrvoider extends ChangeNotifier {
  late TeethController teethController;

  TeethProvider() {
    teethController = TeethController();
  }

  List<TeethData> _teethRecords = []; // Corrected variable name
  List<TeethData> get teethRecords => _teethRecords; // Corrected variable name

  Future addVaccineRecord(TeethData teethData) async {
    print('Adding medication record: $teethData');
    final bool res = await teethController.saveteethData(teethData: teethData);
    if (res) {
      _teethRecords.add(teethData); // Corrected variable name
      notifyListeners();
      print('Medication record added successfully: $_teethRecords');
    } else {
      print('Failed to add medication record');
    }
  }

  Future<List<TeethData>> getVaccineRecords() async {
    try {
      final List<TeethData> res = await teethController.retrieveTeethData();
      _teethRecords = res;
      notifyListeners();
      print('Retrieved vaccine records: $_teethRecords');
      return _teethRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving vaccine records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editVaccineRecord(TeethData teethData) async {
    final bool res = await teethController.editTeeth(teethData);
    if (res) {
      final int index = _teethRecords
          .indexWhere((element) => element.toothId == teethData.toothId);
      _teethRecords[index] = teethData;
      notifyListeners();
    }
  }

  Future deleteVaccineRecord(int vacId) async {
    final bool res = await teethController.deleteTeeth(vacId);
    if (res) {
      _teethRecords.removeWhere((element) => element.toothId == vacId);
      notifyListeners();
    }
  }
}
