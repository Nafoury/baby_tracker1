import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/models/bottleData.dart';
import 'package:baba_tracker/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BottleController {
  Crud crud = Crud();

  Future<bool> savebottlerData({
    required BottleData bottleData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkBottleData,
        {
          "date": bottleData.startDate.toString(),
          "amount": bottleData.amount.toString(),
          "note": bottleData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );
      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('feed1_id')) {
          String bottleId = response['feed1_id'].toString();
          print('feedId: $bottleId');
          bottleData.feed1Id = int.parse(bottleId);
          print(bottleData.feed1Id);
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

  Future<List<BottleData>> retrieveBottleData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkViewBottle, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<BottleData> bottleDataList =
              data.map((item) => BottleData.fromMap(item)).toList();
          return bottleDataList;
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

  Future<bool> deleteRecord(int bottleId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteBottle, {
          "feed1_id": bottleId.toString(),
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

  Future<bool> editRecord(BottleData bottleData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateBottle, {
          "date": bottleData.startDate.toString(),
          "amount": bottleData.amount.toString(),
          "note": bottleData.note,
          "feed1_id": bottleData.feed1Id.toString(),
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
