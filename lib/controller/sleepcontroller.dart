import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/provider/sleep_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SleepController {
  Crud crud = Crud();

  Future<bool> saveSleepData({
    required SleepData sleepData,
  }) async {
    Duration? duration;

    try {
      if (sleepData.endDate != null && sleepData.startDate != null) {
        duration = sleepData.endDate!.difference(sleepData.startDate!);
        if (duration.inMilliseconds > 0) {
          var response = await crud.postrequest(
            linkaddsleep,
            {
              "start_date": sleepData.startDate.toString(),
              "end_date": sleepData.endDate.toString(),
              "duration": duration.inMinutes.toString(),
              "note": sleepData.note,
              "baby_id": sharedPref.getString("info_id")
            },
          );

          print(response); // Print the response to check its structure

          if (response['status'] == "success") {
            if (response.containsKey('sleep_id')) {
              String sleepId = response['sleep_id'].toString();
              print('sleepId: $sleepId');
              sleepData.sleepId = int.parse(sleepId);
              print(sleepData.sleepId);
            } else {
              print(
                  "ID not found in the response"); // Check this print statement
            }
          } else {
            print("addition fail");
          }
        }
      } else {
        print("Either start date or end date is null");
      }

      return true; // Assuming you want to return a boolean indicating success
    } catch (e) {
      print("Error: $e");
      return false; // Return false in case of an error
    }
  }

  Future<List<SleepData>> retrievesleepData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkviewsleep, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<SleepData> sleepDataList =
              data.map((item) => SleepData.fromJson(item)).toList();
          return sleepDataList;
        } else {
          print("Error: Failed to retrieve bottle data");
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

  Future<bool> deleteRecord(int sleepId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeletesleep, {
          "sleep_id": sleepId.toString(),
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

  Future<bool> editRecord(SleepData sleepData) async {
    try {
      if (sleepData.endDate != null && sleepData.startDate != null) {
        // Calculate duration
        Duration duration = sleepData.endDate!.difference(sleepData.startDate!);

        if (duration.inMilliseconds > 0) {
          // Update duration in the SleepData object
          sleepData.duration = duration.inMinutes;

          // Make the API call to update the record
          var response = await crud.postrequest(linkUpdatesleep, {
            "start_date": sleepData.startDate.toString(),
            "end_date": sleepData.endDate.toString(),
            "duration":
                sleepData.duration.toString(), // Use the updated duration
            "note": sleepData.note,
            "sleep_id": sleepData.sleepId.toString(),
          });

          print('Server response: $response');
          return response['status'] == 'success';
        } else {
          print('Invalid duration');
          return false;
        }
      } else {
        print('Either start date or end date is null');
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
