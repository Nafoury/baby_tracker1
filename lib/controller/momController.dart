import 'package:baby_tracker/models/medData.dart';
import 'package:baby_tracker/models/momweightData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';

class MomController {
  Crud crud = Crud();

  Future<bool> saveweightData({
    required MomData momData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddWeight,
        {
          "date": momData.date.toString(),
          "weight": momData.weight.toString(),
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('mom_id')) {
          String momId = response['mom_id'].toString();
          print('medId: $momId');
          momData.momId = int.parse(momId);
          print(momData.momId);
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

  Future<List<MomData>> retrieveWeightData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(
            linkViewWeight, {"baby_id": sharedPref.getString("info_id")});
        print(response);

        if (response['status'] == "success" && response.containsKey('data')) {
          // Parse the data and return it
          List<dynamic> data = response['data'];
          List<MomData> bottleDataList =
              data.map((item) => MomData.fromJson(item)).toList();
          return bottleDataList;
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
}
