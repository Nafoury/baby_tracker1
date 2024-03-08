import 'package:flutter/material.dart';
import 'package:baby_tracker/models/nursingData.dart';

class NursingDataProvider extends ChangeNotifier {
  List<NusringData> nursingRecords = [];

  void setNursingData(List<NusringData> data) {
    nursingRecords = data;
    notifyListeners();
  }
}
