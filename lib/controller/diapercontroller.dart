import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/localDatabase/sqlite_diaperchange.dart';

class DiaperController {
  Crud crud = Crud();
  DiaperDatabase _db = DiaperDatabase();

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

  retrieveDiaperData() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      // Fetch additional data from the API only if the device is online
      var response;
      List<DiaperData> apiData = [];

      if (isOnline) {
        response = await crud.postrequest(
            linkdiaperview, {"baby_id": sharedPref.getString("info_id")});
        apiData = convertData(response);

        // Save the fetched data to the local database
        await _db.saveApiDataToLocal(apiData);
      }

      // Load local data without duplicates
      List<DiaperData> localData = await _db.loadLocalData();
      List<DiaperData> nonDuplicateLocalData = localData
          .where((localDiaper) => !apiData
              .any((apiDiaper) => localDiaper.startDate == apiDiaper.startDate))
          .toList();

      // Combine local and API data
      List<DiaperData> combinedData = [...nonDuplicateLocalData, ...apiData];

      return combinedData;
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list in case of an error
    }
  }

  List<DiaperData> convertData(dynamic data) {
    List<DiaperData> diaperRecords = [];

    if (data is Map && data.containsKey('status') && data.containsKey('data')) {
      // Assuming the response is a valid JSON with 'status' and 'data' fields
      if (data['status'] == 'success') {
        List<dynamic> dataList = data['data'];

        for (var record in dataList) {
          DateTime startDate = DateTime.parse(record['start_date']);
          String status = record['status'];
          String note = record['note'];
          String infoid = sharedPref.getString("info_id") ?? "";
          int changeId = record['change_id']; // Add this line

          DiaperData diaperData = DiaperData(
            changeId: changeId,
            startDate: startDate,
            status: status,
            note: note,
            infoid: infoid,
          );

          diaperRecords.add(diaperData);
        }
      } else {
        // Handle server response indicating failure
        print('Server response indicates failure: ${data['status']}');
      }
    } else {
      // Handle unexpected response format (possibly HTML or other non-JSON format)
      print('Unexpected response format: $data');
    }

    return diaperRecords;
  }
}
