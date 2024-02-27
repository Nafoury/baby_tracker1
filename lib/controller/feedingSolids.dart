import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/solidsData.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';

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
}
