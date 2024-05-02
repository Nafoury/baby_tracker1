import 'package:baby_tracker/controller/feedNursing.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/models/nursingData.dart';

class NursingDataProvider extends ChangeNotifier {
  late NursingController nursingController;

  NursingDataProvider() {
    nursingController = NursingController();
  }
  List<NusringData> _nursingRecords = List<NusringData>.empty(growable: false);
  List<NusringData> get nursingRecords => _nursingRecords;

  Future addNursingData(NusringData nusringData) async {
    print('Adding medication record: $nusringData');
    final bool res =
        await nursingController.savenursingData(nusringData: nusringData);
    if (res) {
      _nursingRecords.add(nusringData); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_nursingRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<NusringData>> getNursingRecords() async {
    try {
      final List<NusringData> res =
          await nursingController.retrieveNursingData();
      _nursingRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_nursingRecords');
      return _nursingRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editNursingRecord(NusringData nusringData) async {
    final bool res = await nursingController.editRecord(nusringData);
    if (res) {
      final int index = _nursingRecords
          .indexWhere((element) => element.feedId == nusringData.feedId);
      _nursingRecords[index] = nusringData;
      notifyListeners();
    }
  }

  Future deleteNursingRecord(int feedId) async {
    final bool res = await nursingController.deleteRecord(feedId);
    if (res) {
      _nursingRecords.removeWhere((element) => element.feedId == feedId);
      notifyListeners();
    }
  }
}
