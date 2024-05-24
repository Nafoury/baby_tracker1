import 'dart:io';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class BabyInfoController {
  Crud crud = Crud();
  BabyInfo babyInfo = BabyInfo();

  Future<bool> saveBabyData({
    required BabyInfo babyInfo,
    File? imagefile,
  }) async {
    try {
      var response;
      if (imagefile != null) {
        response = await crud.postRequest(
          linkAddinfo,
          {
            "baby_name": babyInfo.babyName.toString(),
            "gender": babyInfo.gender.toString(),
            "date_of_birth": babyInfo.dateOfBirth.toString(),
            "baby_weight": babyInfo.babyWeight.toString(),
            "baby_height": babyInfo.babyHeight.toString(),
            "baby_head": babyInfo.babyhead.toString(),
            "complete_info_user_authorization": sharedPref.getString("id")
          },
          imagefile,
        );
      } else {
        response = await crud.postrequest(
          linkAddinfo,
          {
            "baby_name": babyInfo.babyName.toString(),
            "gender": babyInfo.gender.toString(),
            "date_of_birth": babyInfo.dateOfBirth.toString(),
            "baby_weight": babyInfo.babyWeight.toString(),
            "baby_height": babyInfo.babyHeight.toString(),
            "baby_head": babyInfo.babyhead.toString(),
            "complete_info_user_authorization": sharedPref.getString("id")
          },
        );
      }

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('info_id')) {
          String infoId = response['info_id'].toString();
          print('ChangeId: $infoId');
          sharedPref.setString("info_id", infoId);
        } else {
          print("ID not found in the response"); // Check this print statement
        }
      } else {
        print("addition failed");
      }
      return true; // Assuming you want to return a boolean indicating success
    } catch (e) {
      print("Error: $e");
      return false; // Return false in case of an error
    }
  }

  Future<List<BabyInfo>> retrieveBabyData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkViewinfo,
            {"complete_info_user_authorization": sharedPref.getString("id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<BabyInfo> babyDataList =
              data.map((item) => BabyInfo.fromJson(item)).toList();
          return babyDataList;
        } else {
          debugPrint("Error: Failed to baby data");
          return []; // Return an empty list if there's an error
        }
      } else {
        debugPrint("Error: No internet connection");
        return []; // Return an empty list if there's no internet connection
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list in case of an error
    }
  }

  // Inside the function responsible for deleting a baby
  Future<bool> deleteBaby(int infoId) async {
    try {
      // Send request to delete the baby
      var response = await crud
          .postrequest(linkDeleteinfo, {"info_id": infoId.toString()});

      if (response['status'] == 'success') {
        // If deletion is successful
        if (response.containsKey('activate_next') &&
            response['activate_next'] == true) {
          // If the next baby is activated
          // Update local state to reflect the change
          // Optionally, you can refresh the baby list
        }
        return true;
      }
      return false;
    } catch (e) {
      // Handle any exceptions
      print("Error: $e");
      return false;
    }
  }

  Future<bool> editBaby(BabyInfo babyInfo, File? imageFile) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        if (imageFile != null) {
          var response = await crud.postRequest(
              linkUpdateinfo,
              {
                "baby_name": babyInfo.babyName.toString(),
                "date_of_birth": babyInfo.dateOfBirth.toString(),
                "gender": babyInfo.gender.toString(),
                "baby_weight": babyInfo.babyWeight.toString(),
                "baby_height": babyInfo.babyHeight.toString(),
                "baby_head": babyInfo.babyhead.toString(),
                "info_id": babyInfo.infoId.toString()
              },
              imageFile);
          // Print the response for debugging
          print('Server response: $response');

          if (response['status'] == 'success') {
            return true;
          }
          return false;
        } else {
          var response = await crud.postrequest(linkUpdateinfo, {
            "baby_name": babyInfo.babyName.toString(),
            "date_of_birth": babyInfo.dateOfBirth.toString(),
            "gender": babyInfo.gender.toString(),
            "baby_weight": babyInfo.babyWeight.toString(),
            "baby_height": babyInfo.babyHeight.toString(),
            "baby_head": babyInfo.babyhead.toString(),
            "info_id": babyInfo.infoId.toString()
          });
          // Print the response for debugging
          print('Server response: $response');

          if (response['status'] == 'success') {
            return true;
          }
          return false;
        }
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

  Future<void> makeBabyActive(int babyId) async {
    try {
      final response = await crud.postrequest(linkActiveBaby, {
        "info_id": babyId.toString(),
        "complete_info_user_authorization": sharedPref.getString("id")
      });

      if (response != null && response['status'] == 'success') {
        // Update the info_id in shared preferences with the activated baby's info_id
        sharedPref.setString("info_id", babyId.toString());

        print('Baby successfully made active.');
        // You can perform additional actions if needed
      } else {
        print('Failed to make baby active.');
        // Handle failure scenario
      }
    } catch (e) {
      print('Error making baby active: $e');
      // Handle any exceptions that might occur during the request
    }
  }
}
