import 'package:baby_tracker/models/medData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';

class MedController {
  Crud crud = Crud();

  Future<bool> saveMedData({
    required MedData medData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkAddMed,
        {
          "date": medData.date.toString(),
          "type": medData.type,
          "note": medData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );

      print(response); // Print the response to check its structure
      if (response['status'] == "success") {
        if (response.containsKey('med_id')) {
          String medId = response['med_id'].toString();
          print('medId: $medId');
          medData.medId = int.parse(medId);
          print(medData.medId);
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
