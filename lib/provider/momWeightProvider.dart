import 'package:baby_tracker/controller/momController.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:flutter/foundation.dart';

class MomWeightProvider extends ChangeNotifier {
  late MomController momController;

  MomWeightProvider() {
    momController = MomController();
  }
  List<MomData> _weightRecords = List<MomData>.empty(growable: true);
  List<MomData> get weightRecords => _weightRecords;

  Future addWeightData(MomData momData) async {
    print('Adding medication record: $momData');
    final bool res = await momController.saveweightData(momData: momData);
    if (res) {
      _weightRecords.add(momData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_weightRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<MomData>> getWeightRecords() async {
    try {
      final List<MomData> res = await momController.retrieveWeightData();
      _weightRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_weightRecords');
      return _weightRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editWeightRecord(MomData momData) async {
    final bool res = await momController.editWeight(momData);
    if (res) {
      final int index = _weightRecords
          .indexWhere((element) => element.momId == momData.momId);
      _weightRecords[index] = momData;
      notifyListeners();
    }
  }

  Future deleteWeigthRecord(int weightId) async {
    final bool res = await momController.deleteWeight(weightId);
    if (res) {
      _weightRecords.removeWhere((element) => element.momId == weightId);
      notifyListeners();
    }
  }
}
