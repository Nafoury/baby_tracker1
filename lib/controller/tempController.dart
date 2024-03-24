import 'package:baby_tracker/models/tempData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';
import 'package:flutter/cupertino.dart';

class TempController {
  Crud crud = Crud();

  Future<bool> saveTempData({
    required TempData tempData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddTemp,
        {
          "date": tempData.date.toString(),
          "temp": tempData.temp.toString(),
          "note": tempData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('temp_id')) {
          String tempId = response['temp_id'].toString();
          print('ChangeId: $tempId');
          tempData.tempId = int.parse(tempId);
          print(tempData.tempId);
        } else {
          print("ID not found in the response"); // Check this print statement
        }
      } else {
        print("addiyion fail");
      }
      return true; // Assuming you want to return a boolean indicating success
    } catch (e) {
      print("Error: $e");
      return false; // Return false in case of an error
    }
  }

  Future<List<TempData>> retrieveTempData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkGetTemp, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<TempData> tempDataList =
              data.map((item) => TempData.fromJson(item)).toList();
          return tempDataList;
        } else {
          debugPrint("Error: Failed to retrieve bottle data");
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

  Future<bool> deleteTemp(int tempId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteTemp, {
          "temp_id": tempId.toString(),
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

  Future<bool> editDiaper(TempData tempData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateTemp, {
          "date": tempData.date.toString(),
          "temp": tempData.temp.toString(),
          "note": tempData.note,
          "temp_id": tempData.tempId.toString(),
        });
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
