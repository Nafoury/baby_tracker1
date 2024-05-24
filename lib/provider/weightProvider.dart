import 'package:baba_tracker/controller/weightController.dart';
import 'package:baba_tracker/models/babyWeight.dart';
import 'package:baba_tracker/models/momweightData.dart';
import 'package:flutter/foundation.dart';

class WeightProvider extends ChangeNotifier {
  late WeightController weightController;

  WeightProvider() {
    weightController = WeightController();
  }
  List<WeightData> _weightRecords = List<WeightData>.empty(growable: true);
  List<WeightData> get weightRecords => _weightRecords;

  Future addWeightData(WeightData weightData) async {
    print('Adding medication record: $weightData');
    final bool res =
        await weightController.saveweightData(weightData: weightData);
    if (res) {
      _weightRecords.add(weightData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_weightRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<WeightData>> getWeightRecords() async {
    try {
      final List<WeightData> res = await weightController.retrieveWeightData();
      _weightRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_weightRecords');
      return _weightRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editWeightRecord(WeightData weightData) async {
    final bool res = await weightController.editWeight(weightData);
    if (res) {
      final int index = _weightRecords
          .indexWhere((element) => element.weightId == weightData.weightId);
      _weightRecords[index] = weightData;
      notifyListeners();
    }
  }

  Future deleteWeigthRecord(int weightId) async {
    final bool res = await weightController.deleteWeight(weightId);
    if (res) {
      _weightRecords.removeWhere((element) => element.weightId == weightId);
      notifyListeners();
    }
  }
}
