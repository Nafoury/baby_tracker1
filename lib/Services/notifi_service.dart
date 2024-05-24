import 'dart:developer';

import 'package:baba_tracker/models/vaccineData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  static void showBasicNotification() async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'id 1',
        'basic notification',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'Reminder', 'Time for baby medication', details);
  }

  static Future<void> showScheduledNotification(DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Vaccine Reminder',
      'It\'s time for your baby\'s vaccine',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'id 1',
          'scheduled notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void showSchduledNotification1(
      DateTime currentDate, String type) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 2',
      'Scheduled Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    log(tz.local.name);
    log(tz.TZDateTime.now(tz.local).hour.toString());
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    log(currentTimeZone);
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    log(tz.local.name);
    log("Current time: ${tz.TZDateTime.now(tz.local).hour}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Vaccine Reminder",
      "$type for baby ",
      tz.TZDateTime(
        tz.local,
        currentDate.year,
        currentDate.month,
        currentDate.day,
        currentDate.hour,
        currentDate.minute,
      ),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("notifiaction is created");
  }

  static Future<void> showScheduledNotificationRepeated(
      DateTime scheduledTime, Duration interval) async {
    await Workmanager().registerPeriodicTask(
      'reminder_task',
      'reminder_task',
      frequency: interval,
      initialDelay: scheduledTime.difference(DateTime.now()),
      inputData: {'interval': interval.inMinutes.toString()},
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  static Future<void> cancelScheduledNotification() async {
    await Workmanager().cancelByUniqueName('reminder_task');
  }
}
