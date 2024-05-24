import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/models/nursingData.dart';
import 'package:baba_tracker/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NursingController {
  Crud crud = Crud();

  Future<bool> savenursingData({
    required NusringData nusringData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddNursing,
        {
          "left_duration": nusringData.leftDuration,
          "date": nusringData.date.toString(),
          "nursing_side": nusringData.nursingSide,
          "starting_side": nusringData.startingBreast,
          "right_duration": nusringData.rightDuration,
          "baby_id": sharedPref.getString("info_id")
        },
      );
      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('feed_id')) {
          String feedId = response['feed_id'].toString();
          print('feedId: $feedId');
          nusringData.feedId = int.parse(feedId);
          print(nusringData.feedId);
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

  Future<List<NusringData>> retrieveNursingData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkViewNursing, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<NusringData> nursingDataList =
              data.map((item) => NusringData.fromJson(item)).toList();
          return nursingDataList;
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

  Future<bool> deleteRecord(int nursingId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteNursing, {
          "feed_id": nursingId.toString(),
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

  Future<bool> editRecord(NusringData nusringData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateNursing, {
          "left_duration": nusringData.leftDuration,
          "date": nusringData.date.toString(),
          "nursing_side": nusringData.nursingSide,
          "starting_side": nusringData.startingBreast,
          "right_duration": nusringData.rightDuration,
          "feed_id": nusringData.feedId.toString(),
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
