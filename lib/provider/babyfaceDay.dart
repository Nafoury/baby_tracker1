import 'dart:io';

import 'package:baba_tracker/controller/faceDayController.dart';

import 'package:baba_tracker/models/faceModel.dart';
import 'package:flutter/foundation.dart';

class FaceDayProvider extends ChangeNotifier {
  late FaceDayController faceDayController;

  FaceDayProvider() {
    faceDayController = FaceDayController();
  }

  List<FaceData> _faceData = []; // Corrected variable name
  List<FaceData> get faceData => _faceData; // Corrected variable name

  Future<bool> saveUserImage(
      {required FaceData faceData, required File imageFile}) async {
    try {
      final bool success = await faceDayController.savefaceData(
          faceData: faceData, imagefile: imageFile);
      if (success) {
        await getImageRecord(); // Update user image data after saving
      }
      notifyListeners();
      return success;
    } catch (e) {
      print('Error saving user image: $e');
      throw e;
    }
  }

  Future<List<FaceData>> getImageRecord() async {
    try {
      final List<FaceData> res = await faceDayController.retrievefaceData();
      _faceData = res;
      notifyListeners();
      print('Retrieved vaccine records: $_faceData');
      return _faceData; // Return the retrieved records
    } catch (e) {
      print('Error retrieving vaccine records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future<bool> deleteUserImage(int image) async {
    try {
      final bool success = await faceDayController.deleteImage(image);
      if (success) {
        await getImageRecord(); // Update user image data after deletion
      }
      notifyListeners();
      return success;
    } catch (e) {
      print('Error deleting user image: $e');
      throw e;
    }
  }

  Future<bool> editUserImage(
      {required FaceData faceData, required File imageFile}) async {
    try {
      final bool success =
          await faceDayController.editImage(faceData, imagefile: imageFile);
      if (success) {
        await getImageRecord(); // Update user image data after editing
      }
      notifyListeners();
      return success;
    } catch (e) {
      print('Error editing user image: $e');
      throw e;
    }
  }
}
