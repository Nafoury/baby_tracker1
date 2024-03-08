import 'package:flutter/material.dart';
import 'package:baby_tracker/models/solidsData.dart';

class SolidsDataProvider extends ChangeNotifier {
  List<SolidsData> solidsRecords = [];

  void setSolidsData(List<SolidsData> data) {
    solidsRecords = data;
    notifyListeners();
  }
}
