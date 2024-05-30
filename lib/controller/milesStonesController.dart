import 'package:baba_tracker/models/milestonesModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/main.dart';

class MileStonesController {
  Crud crud = Crud();

  Future<bool> saveData({
    required MilestoneData milestones,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddMileStone,
        {
          "date": milestones.date.toString(),
          "label": milestones.label.toString(),
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('milestone_id')) {
          String mileStone = response['milestone_id'].toString();
          print('milestoneId: $mileStone');
          milestones.milestoneId = int.parse(mileStone);
          print(milestones.milestoneId);
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

  Future<List<MilestoneData>> retrieveWeightData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkReadMileStone, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<MilestoneData> mileStonesDataList =
              data.map((item) => MilestoneData.fromJson(item)).toList();
          return mileStonesDataList;
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

  Future<bool> deleteData(int milesStoneId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteMileStone, {
          "milestone_id": milesStoneId.toString(),
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

  Future<bool> editData(MilestoneData milestoneData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateMileStone, {
          "date": milestoneData.date.toString(),
          "milestone_id": milestoneData.milestoneId.toString(),
        });

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
