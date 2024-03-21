import 'package:baby_tracker/controller/vaccinecontroller.dart';
import 'package:baby_tracker/models/vaccineData.dart';
import 'package:flutter/foundation.dart';

class VaccineProvider extends ChangeNotifier {
  late VaccineController vaccineController;

  VaccineProvider() {
    vaccineController = VaccineController();
  }

  List<VaccineData> _vaccineRecords = []; // Corrected variable name
  List<VaccineData> get vaccineRecords =>
      _vaccineRecords; // Corrected variable name

  Future addVaccineRecord(VaccineData vaccineData) async {
    print('Adding medication record: $vaccineData');
    final bool res =
        await vaccineController.saveVaccineData(vaccineData: vaccineData);
    if (res) {
      _vaccineRecords.add(vaccineData); // Corrected variable name
      notifyListeners();
      print('Medication record added successfully: $_vaccineRecords');
    } else {
      print('Failed to add medication record');
    }
  }

  Future<List<VaccineData>> getVaccineRecords() async {
    try {
      final List<VaccineData> res =
          await vaccineController.retrieveVaccineData();
      _vaccineRecords = res;
      notifyListeners();
      print('Retrieved vaccine records: $_vaccineRecords');
      return _vaccineRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving vaccine records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editVaccineRecord(VaccineData vaccineData) async {
    final bool res = await vaccineController.editVaccine(vaccineData);
    if (res) {
      final int index = _vaccineRecords
          .indexWhere((element) => element.vaccineId == vaccineData.vaccineId);
      _vaccineRecords[index] = vaccineData;
      notifyListeners();
    }
  }

  Future deleteVaccineRecord(int vacId) async {
    final bool res = await vaccineController.deleteVaccine(vacId);
    if (res) {
      _vaccineRecords.removeWhere((element) => element.vaccineId == vacId);
      notifyListeners();
    }
  }
}
