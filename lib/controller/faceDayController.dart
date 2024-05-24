import 'dart:io';
import 'package:baba_tracker/models/faceModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/main.dart';
import 'package:flutter/material.dart';

class FaceDayController {
  Crud crud = Crud();

  Future<bool> savefaceData({
    required FaceData faceData,
    required File imagefile,
  }) async {
    try {
      String? infoId = sharedPref.getString("info_id");
      if (infoId != null) {
        var response = await crud.postRequest(
          linkAddFaceImage,
          {
            "date": faceData.date.toString(),
            "baby_id": infoId,
          },
          imagefile,
        );

        print(response); // Print the response to check its structure
        if (response['status'] == "success") {
          if (response.containsKey('image_id')) {
            String imageid = response['image_id'].toString();
            print('imageId: $imageid');
            faceData.imageId = int.parse(imageid);
          } else {
            print("ID not found in the response"); // Check this print statement
          }
        } else {
          print("addition failed");
        }
      }
      return true; // Assuming you want to return a boolean indicating success
    } catch (e) {
      print("Error: $e");
      return false; // Return false in case of an error
    }
  }

  Future<List<FaceData>> retrievefaceData() async {
    try {
      // Retrieve the info_id of the activated baby from shared preferences
      String? infoId = sharedPref.getString("info_id");

      if (infoId != null) {
        // Check for internet connectivity
        ConnectivityResult connectivityResult =
            await Connectivity().checkConnectivity();
        bool isOnline = (connectivityResult != ConnectivityResult.none);

        if (isOnline) {
          var response =
              await crud.postrequest(linkReadFaceImage, {"baby_id": infoId});
          print(response);

          if (response['status'] == "success" && response.containsKey('data')) {
            // Parse the data and return it
            List<dynamic> data = response['data'];
            List<FaceData> diaperDataList =
                data.map((item) => FaceData.fromJson(item)).toList();
            return diaperDataList;
          } else {
            debugPrint("Error: Failed to retrieve diaper data");
            return []; // Return an empty list if there's an error
          }
        } else {
          debugPrint("Error: No internet connection");
          return []; // Return an empty list if there's no internet connection
        }
      } else {
        print("Error: info_id is null");
        return []; // Return an empty list if info_id is null
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<bool> deleteImage(int imageId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteFaceImage, {
          "image_id": imageId.toString(),
        });
        if (response['status'] == 'success') {
          return true;
        }
        return false;
      } else {
        // Handle the case where there is no internet connection
        print('No internet connection. Cannot update data.');
      }
      return false;
    } catch (e) {
      // Handle any exceptions that might occur during the update process
      print("Error: $e");
      return false;
    }
  }

  Future<bool> editImage(FaceData faceData, {required File imagefile}) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postRequest(
          linkUpdateFaceImage,
          {
            "date": faceData.date.toString(),
            "face_image": faceData.image,
            "image_id": faceData.imageId.toString()
          },
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
