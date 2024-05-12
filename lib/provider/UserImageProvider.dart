import 'dart:io';
import 'package:baby_tracker/controller/UserImageController.dart';
import 'package:baby_tracker/models/ImageModel.dart';
import 'package:flutter/foundation.dart';

class UserImageProvider extends ChangeNotifier {
  late UserImageController userImageController;

  UserImageProvider() {
    userImageController = UserImageController();
  }

  List<UserData> _userData = []; // Corrected variable name
  List<UserData> get userData => _userData; // Corrected variable name

  Future<bool> saveUserImage(
      {required UserData userData, required File imageFile}) async {
    try {
      final bool success = await userImageController.savefaceData(
          userData: userData, imagefile: imageFile);
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

  Future<List<UserData>> getImageRecord() async {
    try {
      final List<UserData> res = await userImageController.retrievefaceData();
      _userData = res;
      notifyListeners();
      print('Retrieved vaccine records: $_userData');
      return _userData; // Return the retrieved records
    } catch (e) {
      print('Error retrieving vaccine records: $e');
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future<bool> deleteUserImage(String image) async {
    try {
      final bool success = await userImageController.deleteImage(image);
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
      {required UserData userData, required File imageFile}) async {
    try {
      final bool success =
          await userImageController.editImage(userData, imagefile: imageFile);
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
