import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inno_schedule/local_storage.dart';
import 'package:inno_schedule/services/notification_service/notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Russia/Moscow'));


    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('iu_icon_2');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {}
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {});
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'IU schedule',
          channelDescription: 'Reminds you about the lectures, tutorials or labs in IU. You set those events to remind by your own.',
      importance: Importance.max),
      iOS: DarwinNotificationDetails()
    );
  }

  Future showNotification(
  {int id = 0, String? title, String? body, String? payload}
      ) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  static Future scheduleNotification(DateTime startDateTime,
      {int id = 0, String? title, String? body, String? payload}
      ) async {
    var time = startDateTime;

    while (time.isBefore(DateTime.now().add(const Duration(minutes: 10)))) {
      time = time.add(const Duration(days: 7));
    }

    notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time.add(const Duration(days: 7)), tz.local).subtract(const Duration(minutes: 10)),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

    notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time.add(const Duration(days: 14)), tz.local).subtract(const Duration(minutes: 10)),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(time, tz.local).subtract(const Duration(minutes: 10)),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static bool eventNotificationsEnabled(String event) {
    print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHH${event}');
    try {
      var notifications = LocalStorageService.getNotifications();
      return notifications.getMap.containsKey(event);
    } catch (e) {
      // No need to do something here
    }
    return false;
  }

  static void switchNotifications(String event, DateTime startDateTime,
      {int id = 0, String? title, String? body, String? payload}) {
    Notifications notifications;
    try {
      notifications = LocalStorageService.getNotifications();
    } catch (e) {
      notifications = Notifications(currentId: 0, map: <String, bool>{});
    }

    if (notifications.getMap.containsKey(event)) {
      notifications.getMap.remove(event);
    } else {
      notifications.getMap[event] = true;
      scheduleNotification(
          startDateTime,
        id: id,
        title: title,
        body: body
      );
    }

    LocalStorageService.saveNotifications(notifications);
  }
}