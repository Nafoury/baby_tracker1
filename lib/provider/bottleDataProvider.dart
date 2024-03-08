import 'package:flutter/material.dart';
import 'package:baby_tracker/models/bottleData.dart';

class BottleDataProvider extends ChangeNotifier {
  List<BottleData> bottleRecords = [];

  void setBottleData(List<BottleData> data) {
    bottleRecords = data;
    notifyListeners();
  }
}
