import 'package:baby_tracker/controller/babyinfoController.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:flutter/foundation.dart';

class BabyProvider extends ChangeNotifier {
  late BabyInfoController babyInfoController;

  BabyProvider() {
    babyInfoController = BabyInfoController();
  }
  List<BabyInfo> _babyRecords = List<BabyInfo>.empty(growable: true);
  List<BabyInfo> get babyRecords => _babyRecords;

  Future addBabyData(BabyInfo babyInfo) async {
    print('Adding medication record: $babyInfo');
    final bool res = await babyInfoController.saveBabyData(babyInfo: babyInfo);
    if (res) {
      _babyRecords.add(babyInfo); // Corrected variable name
      notifyListeners();
      print('Diaper record added successfully: $_babyRecords');
    } else {
      print('Failed to add diaper record');
    }
  }

  Future<List<BabyInfo>> getbabyRecords() async {
    try {
      final List<BabyInfo> res = await babyInfoController.retrieveBabyData();
      _babyRecords = res;
      notifyListeners();
      print('Retrieved medication records: $_babyRecords');
      return _babyRecords; // Return the retrieved records
    } catch (e) {
      print('Error retrieving medication records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future editBabyRecord(BabyInfo babyInfo) async {
    final bool res = await babyInfoController.editBaby(babyInfo);
    if (res) {
      final int index = _babyRecords
          .indexWhere((element) => element.infoId == babyInfo.infoId);
      _babyRecords[index] = babyInfo;
      notifyListeners();
    }
  }

  Future deleteBabyRecord(int babyInfo) async {
    final bool res = await babyInfoController.deleteBaby(babyInfo);
    if (res) {
      _babyRecords.removeWhere((element) => element.infoId == babyInfo);
      notifyListeners();
    }
  }

  Future makeBabyActive(int babyId) async {
    try {
      await babyInfoController.makeBabyActive(babyId);
      // You may want to fetch the updated list of babies after making one active
      await getbabyRecords();
    } catch (e) {
      print('Error making baby active: $e');
      // Handle error appropriately
    }
  }
}
