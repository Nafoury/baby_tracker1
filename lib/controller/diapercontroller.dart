import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/main.dart';
import 'package:flutter/cupertino.dart';

class DiaperController {
  Crud crud = Crud();

  Future<bool> saveDiaperData({
    required DiaperData diaperData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkdiaperchange,
        {
          "start_date": diaperData.startDate.toString(),
          "status": diaperData.status,
          "note": diaperData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('change_id')) {
          String changeId = response['change_id'].toString();
          print('ChangeId: $changeId');
          diaperData.changeId = int.parse(changeId);
          print(diaperData.changeId);
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

  Future<List<DiaperData>> retrieveDiaperData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkdiaperview, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<DiaperData> diaperDataList =
              data.map((item) => DiaperData.fromMap(item)).toList();
          return diaperDataList;
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

  Future<bool> deleteDiaper(int diaperId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteRecord, {
          "change_id": diaperId.toString(),
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

  Future<bool> editDiaper(DiaperData diaperData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateDiaper, {
          "start_date": diaperData.startDate.toString(),
          "status": diaperData.status,
          "note": diaperData.note,
          "change_id": diaperData.changeId.toString(),
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
