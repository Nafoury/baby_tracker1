import 'dart:io';
import 'package:baby_tracker/models/ImageModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';

class UserImageController {
  Crud crud = Crud();

  Future<bool> savefaceData({
    required UserData userData,
    required File imagefile,
  }) async {
    try {
      var response = await crud.postRequest(
        linkUserImage,
        {"id": sharedPref.getString("id")},
        imagefile,
      );
      print(response); // Print the response to check its structure
      return true; // Assuming you want to return a boolean indicating success
    } catch (e) {
      print("Error: $e");
      return false; // Return false in case of an error
    }
  }

  Future<List<UserData>> retrievefaceData() async {
    Crud crud = new Crud();
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud
            .postrequest(linkReadUserImage, {"id": sharedPref.getString("id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<UserData> userDataList =
              data.map((item) => UserData.fromJson(item)).toList();
          return userDataList;
        } else {
          print("Error: Failed to retrieve weight data");
          return []; // Return an empty list if there's an error
        }
      } else {
        print("Error: No internet connection");
        return []; // Return an empty list if there's no internet connection
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<bool> deleteImage(String image) async {
    try {
      var response = await crud.postrequest(linkDeleteUserImage,
          {"id": sharedPref.getString("id"), "image": image});
      if (response['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> editImage(UserData userData, {required File imagefile}) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postRequest(
          linkUpdateUserImage,
          {"id": sharedPref.getString("id")},
          imagefile,
        );
        // Print the response for debugging
        print('Server response: $response');

        if (response['status'] == 'success') {
          return true;
        }
        return false;
      } else {
        // Handle the case where there is no internet connection
        print('No internet connection. Cannot update data.');
        return false;
      }
    } catch (e) {
      // Handle any exceptions that might occur during the update process
      print("Error: $e");
      return false;
    }
  }
}
