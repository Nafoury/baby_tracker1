import 'package:baba_tracker/models/vaccineData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/models/diaperData.dart';
import 'package:baba_tracker/main.dart';
import 'package:flutter/cupertino.dart';

class VaccineController {
  Crud crud = Crud();

  Future<bool> saveVaccineData({
    required VaccineData vaccineData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddvaccine,
        {
          "date": vaccineData.date.toString(),
          "type": vaccineData.type,
          "note": vaccineData.note,
          "is_reminder_set": vaccineData.isReminderSet == true ? '1' : '0',
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('vaccine_id')) {
          String vaccineId = response['vaccine_id'].toString();
          print('vaccineId: $vaccineId');
          vaccineData.vaccineId = int.parse(vaccineId);
          print(vaccineData.vaccineId);
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

  Future<List<VaccineData>> retrieveVaccineData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkViewvaccine, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<VaccineData> vaccineDataList =
              data.map((item) => VaccineData.fromJson(item)).toList();
          return vaccineDataList;
        } else {
          print("Error: Failed to retrieve bottle data");
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

  Future<bool> deleteVaccine(int vacId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeletevaccine, {
          "vaccine_id": vacId.toString(),
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

  Future<bool> editVaccine(VaccineData vaccineData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdatevaccine, {
          "date": vaccineData.date.toString(),
          "type": vaccineData.type,
          "note": vaccineData.note,
          "is_reminder_set": vaccineData.isReminderSet == true ? '1' : '0',
          "vaccine_id": vaccineData.vaccineId.toString(),
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
