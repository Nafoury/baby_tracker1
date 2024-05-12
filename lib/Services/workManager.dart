/*import 'dart:developer';
import 'package:baby_tracker/Services/notifi_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  void registerMtTask() async {
    await Workmanager().registerOneOffTask('id', 'show name1');
  }

  Future<void> init() async {
    await Workmanager().initialize(actiontask, isInDebugMode: true);
    registerMtTask();
  }

  void canceltask(String id) {
    Workmanager().cancelByUniqueName(id);
  }

  @pragma('vm:entry-point')
  void actiontask() {
    //show notification
    Workmanager().executeTask((taskName, inputData) {
      NotificationService.showBasicNotification();
      return Future.value(true);
    });
  }
}
*/