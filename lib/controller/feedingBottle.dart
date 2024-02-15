import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/models/bottleData.dart';
import 'package:baby_tracker/main.dart';

class BottleController {
  Crud crud = Crud();

  Future<bool> savebottlerData({
    required BottleData bottleData,
  }) async {
    try {
      var response = await crud.postrequest(
        linkBottleData,
        {
          "date": bottleData.date.toString(),
          "amount": bottleData.amount.toString(),
          "note": bottleData.note,
          "baby_id": sharedPref.getString("info_id")
        },
      );

      // Assuming the response contains a boolean value indicating success
      return response['success'] ?? false;
    } catch (e) {
      // Handle any exceptions or errors here
      return false;
    }
  }
}
