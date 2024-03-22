import 'package:baby_tracker/controller/feedingSolids.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:flutter/foundation.dart';

class SolidsProvider extends ChangeNotifier {
  late SolidsController solidsController;

  SolidsProvider() {
    solidsController = SolidsController();
  }
  List<SolidsData> _solidsRecords = List<SolidsData>.empty(growable: true);
  List<SolidsData> get solidsRecords => _solidsRecords;

  Future addSolidsData(SolidsData solidsData) async {
    print('Adding medication record: $solidsData');
    final bool res =
        await solidsController.savebottlerData(solidsData: solidsData);
    if (res) {
      _solidsRecords.add(solidsData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_solidsRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<SolidsData>> getSolidsRecords() async {
    try {
      final List<SolidsData> res = await solidsController.retrieveSolidsData();
      _solidsRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_solidsRecords');
      return _solidsRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editSolidsRecord(SolidsData solidsData) async {
    final bool res = await solidsController.editRecord(solidsData);
    if (res) {
      final int index = _solidsRecords
          .indexWhere((element) => element.solidId == solidsData.solidId);
      _solidsRecords[index] = solidsData;
      notifyListeners();
    }
  }

  Future deleteSolidsRecord(int solidId) async {
    final bool res = await solidsController.deleteRecord(solidId);
    if (res) {
      _solidsRecords.removeWhere((element) => element.solidId == solidId);
      notifyListeners();
    }
  }
}
