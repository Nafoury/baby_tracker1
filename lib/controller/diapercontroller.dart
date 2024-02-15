import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/main.dart';

class DiaperController {
  Crud crud = Crud();

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

      // Assuming the response contains a boolean value indicating success
      return response['success'] ?? false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
