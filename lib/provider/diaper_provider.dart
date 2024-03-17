import 'package:baby_tracker/controller/diapercontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DiaperProvider extends ChangeNotifier {
  // late SharedPreferences sharedPref;
  late DiaperController diaperController;
  DiaperProvider() {
    diaperController = DiaperController();
  }
  List<DiaperData> _diaperRecords = List<DiaperData>.empty(growable: true);
  List<DiaperData> get diaperRecords => _diaperRecords;

  Future addDiaperRecord(DiaperData diaperData) async {
    final bool res =
        await diaperController.saveDiaperData(diaperData: diaperData);
    if (res) {
      _diaperRecords.add(diaperData);
      notifyListeners();
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

  Future getDiaperRecords() async {
    final List<DiaperData> res = await diaperController.retrieveDiaperData();
    _diaperRecords = res;
    notifyListeners();
  }
}
