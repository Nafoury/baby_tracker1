import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/models/solidsData.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SolidsController {
  Crud crud = Crud();

  Future<bool> savebottlerData({
    required SolidsData solidsData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddSolids,
        {
          "date": solidsData.date.toString(),
          "fruits": solidsData.fruits.toString(),
          "veg": solidsData.veg.toString(),
          "protein": solidsData.protein.toString(),
          "grains": solidsData.grains.toString(),
          "dairy": solidsData.dairy.toString(),
          "note": solidsData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );
      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('solid_id')) {
          String solidId = response['solid_id'].toString();
          print('solidid: $solidId');
          solidsData.solidId = int.parse(solidId);
          print(solidsData.solidId);
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

  Future<List<SolidsData>> retrieveSolidsData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkViewSolids, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<SolidsData> solidsDataList =
              data.map((item) => SolidsData.fromJson(item)).toList();
          return solidsDataList;
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

  Future<bool> deleteRecord(int solidId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteSolids, {
          "solid_id": solidId.toString(),
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

  Future<bool> editRecord(SolidsData solidsData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateSolids, {
          "date": solidsData.date.toString(),
          "fruits": solidsData.fruits.toString(),
          "veg": solidsData.veg.toString(),
          "protein": solidsData.protein.toString(),
          "grains": solidsData.grains.toString(),
          "dairy": solidsData.dairy.toString(),
          "note": solidsData.note,
          "solid_id": solidsData.solidId.toString(),
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
