import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SleepController {
  Crud crud = Crud();
  SleepDataProvider sleepDataProvider = SleepDataProvider();

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
}
