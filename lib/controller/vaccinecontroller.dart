import 'package:baby_tracker/models/vaccineData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/localDatabase/sqlite_diaperchange.dart';

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
}
