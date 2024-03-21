import 'package:baby_tracker/controller/medController.dart';
import 'package:baby_tracker/models/medData.dart';
import 'package:flutter/foundation.dart';

class MedicationsProvider extends ChangeNotifier {
  late MedController medController;

  MedicationsProvider() {
    medController = MedController();
  }

  List<MedData> _medicationRecords = []; // Corrected variable name
  List<MedData> get medicationRecords =>
      _medicationRecords; // Corrected variable name

  Future addMedicationRecord(MedData medData) async {
    print('Adding medication record: $medData');
    final bool res = await medController.saveMedData(medData: medData);
    if (res) {
      _medicationRecords.add(medData); // Corrected variable name
      notifyListeners();
      print('Medication record added successfully: $_medicationRecords');
    } else {
      print('Failed to add medication record');
    }
  }

  Future<List<MedData>> getMedicationRecords() async {
    try {
      final List<MedData> res = await medController.retrieveMediciationData();
      _medicationRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_medicationRecords');
      return _medicationRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editMedicationRecord(MedData medData) async {
    final bool res = await medController.editMedication(medData);
    if (res) {
      final int index = _medicationRecords
          .indexWhere((element) => element.medId == medData.medId);
      _medicationRecords[index] = medData;
      notifyListeners();
    }
  }

  Future deleteMedicationRecord(int medId) async {
    final bool res = await medController.deleteMedication(medId);
    if (res) {
      _medicationRecords.removeWhere((element) => element.medId == medId);
      notifyListeners();
    }
  }
}
