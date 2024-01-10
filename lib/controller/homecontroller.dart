import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/sleepData.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/provider/sleep_provider.dart';

class SleepController {
  Crud crud = Crud();
  SleepDataProvider sleepDataProvider = SleepDataProvider();

  Future<bool> saveSleepData({
    required SleepData sleepData,
  }) async {
    try {
      Duration duration = sleepData.endDate.difference(sleepData.startDate);
      if (duration.inMilliseconds > 0) {
        var response = await crud.postrequest(
          linkaddsleep,
          {
            "strat_date": sleepData.startDate.toString(),
            "end_date": sleepData.endDate.toString(),
            "duration": duration.inHours.toString(),
            "id": sharedPref.getString("id")
          },
        );
        sleepDataProvider.addOrUpdateSleepRecord(sleepData);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
