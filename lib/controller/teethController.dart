import 'package:baba_tracker/models/teethModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/main.dart';

class TeethController {
  Crud crud = Crud();

  Future<bool> saveteethData({
    required TeethData teethData,
  }) async {
    try {
      String? infoId = sharedPref.getString("info_id");
      var response = await crud.postrequest(
        linkAddTooth,
        {
          "date": teethData.date.toString(),
          "upper_jaw": teethData.upper.toString(),
          "lower_jaw": teethData.lower.toString(),
          "baby_id": infoId
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('teeth_id')) {
          String momId = response['teeth_id'].toString();
          print('medId: $momId');
          teethData.toothId = int.parse(momId);
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

  Future<List<TeethData>> retrieveTeethData() async {
    try {
      String? infoId = sharedPref.getString("info_id");
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response =
            await crud.postrequest(linkReadTooth, {"baby_id": infoId});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<TeethData> teethDataList =
              data.map((item) => TeethData.fromJson(item)).toList();
          return teethDataList;
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

  Future<bool> deleteTeeth(int teethId) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkDeleteTooth, {
          "teeth_id": teethId.toString(),
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

  Future<bool> editTeeth(TeethData teethData) async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateTooth, {
          "date": teethData.date.toString(),
          "upper_jaw": teethData.upper.toString(),
          "lower_jaw": teethData.lower.toString(),
          "teeth_id": teethData.toothId.toString(),
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
