import 'package:workmanager/workmanager.dart';
import 'package:baba_tracker/Services/notifi_service.dart';

class WorkManagerService {
  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  void cancelTask(String id) {
    Workmanager().cancelByUniqueName(id);
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final String interval =
        inputData!['interval'] ?? '60'; // Default to 60 minutes
    final Duration repeatInterval = Duration(minutes: int.parse(interval));
    final DateTime scheduledTime = DateTime.now().add(repeatInterval);
    print(interval);
    print(scheduledTime);

    await NotificationService.showScheduledNotificationRepeated(
        scheduledTime, repeatInterval);
    NotificationService.showBasicNotification();

    return Future.value(true);
  });
}
