import 'dart:io';
import 'package:baba_tracker/controller/babyinfoController.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:flutter/foundation.dart';

class BabyProvider extends ChangeNotifier {
  late BabyInfoController babyInfoController;

  BabyProvider() {
    babyInfoController = BabyInfoController();
    fetchAndSetActiveBaby();
  }
  List<BabyInfo> _babyRecords = List<BabyInfo>.empty(growable: true);
  List<BabyInfo> get babyRecords => _babyRecords;

  String? _activeBabyId; // Changed from String? to int?
  String? get activeBabyId => _activeBabyId;

  BabyInfo? _activeBaby;

  BabyInfo? get activeBaby => _activeBaby;

  void addListener(void Function() listener) {
    super.addListener(listener);
    // Call the listener immediately upon addition to ensure the UI is updated
    listener();
  }

  Future addBabyData(BabyInfo babyInfo, File? imageFile) async {
    print('Adding baby record: $babyInfo');
    final bool res = await babyInfoController.saveBabyData(
        babyInfo: babyInfo, imagefile: imageFile);
    if (res) {
      _babyRecords.add(babyInfo);
      notifyListeners();
      print('Baby record added successfully: $_babyRecords');
    } else {
      print('Failed to add baby record');
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

  Future editBabyRecord(BabyInfo babyInfo, File? image) async {
    final bool res = await babyInfoController.editBaby(babyInfo, image);
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

  Future<void> fetchAndSetActiveBaby() async {
    try {
      String? activeBabyId = sharedPref.getString("info_id");

      _babyRecords = await babyInfoController.retrieveBabyData();
      if (_babyRecords.isNotEmpty) {
        if (activeBabyId != null && int.tryParse(activeBabyId) != null) {
          _activeBaby = _babyRecords.firstWhere(
            (baby) => baby.infoId == int.parse(activeBabyId),
            orElse: () => _babyRecords.first,
          );
          _activeBabyId = activeBabyId;
        } else {
          _activeBaby = _babyRecords.firstWhere((baby) => baby.isActive == true,
              orElse: () => _babyRecords.first);
          _activeBabyId = _activeBaby!.infoId.toString();
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching baby records: $e');
    }
  }

  Future<void> saveActiveBabyId(String babyId) async {
    await sharedPref.setString("info_id", babyId);
  }

  Future makeBabyActive(int babyId) async {
    try {
      await babyInfoController.makeBabyActive(babyId);
      // You may want to fetch the updated list of babies after making one active
      await getbabyRecords();
      _activeBabyId = babyId.toString();
      // Update _activeBaby with the active baby's information

      _activeBaby = _babyRecords.firstWhere(
        (baby) => baby.infoId == int.parse(_activeBabyId!),
        orElse: () =>
            BabyInfo(), // Return a default BabyInfo object if active baby is not found
      );
      await saveActiveBabyId(_activeBabyId!);
      notifyListeners();
    } catch (e) {
      print('Error making baby active: $e');
      // Handle error appropriately
    }
  }
}
