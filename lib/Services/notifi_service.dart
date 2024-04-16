import 'package:baby_tracker/models/medData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'dart:developer';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}
  static Future init() async {
    InitializationSettings settings = InitializationSettings(
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
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'id 1',
        'basic notification',
      ),
    );
    await flutterLocalNotificationsPlugin.show(0, 'basic', 'not', details);
  }

  static Future<void> showSchduledNotification(DateTime scheduledTime) async {
    MedData medData;
    print('Scheduled time received: $scheduledTime');
    const AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 2', 'Sechuled notificaton',
        importance: Importance.high);
    NotificationDetails details = const NotificationDetails(android: android);
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      androidAllowWhileIdle: true,
      1,
      'Scheduled Notification',
      'This is a scheduled notification',
      _nextInstanceOfTime(scheduledTime),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(DateTime scheduledTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> showScheduledNotification(
      DateTime scheduledTime, Duration interval) async {
    print('Scheduled time1 received: $scheduledTime');
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 2',
      'Scheduled notification',
      importance: Importance.high,
    );
    NotificationDetails details = NotificationDetails(android: android);
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Reminder',
        'It\'s time for your reminder!', RepeatInterval.hourly, details,
        androidAllowWhileIdle: true);
  }
}
