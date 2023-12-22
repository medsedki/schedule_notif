import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'dart:developer';

import 'Reveil.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// Others
  Future periodicallyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      await notificationDetails(),
    );
  }

  void scheduleAlarms(List<Reveil> reveils) async {
    log("start scheduleAlarms");
    initializeTimezoneForApp();

    for (Reveil reveil in reveils) {
      final notificationTimes = calculateNotificationTimes(reveil);
      log("notificationTimes=${notificationTimes.length}");
      log("notificationTimes=${notificationTimes.toList().toString()}");
      log('Time Zone: ${getLocation('Africa/Tunis').timeZone}');

      for (DateTime notificationTime in notificationTimes) {
        final tz.TZDateTime scheduledTZTime = TZDateTime.from(
          notificationTime,
          getLocation('Africa/Tunis'),
        );
        log('notificationTime=$notificationTime');
        log('scheduledTZTime=$scheduledTZTime');

        var notifTime = _convertTime(notificationTime);

        await notificationsPlugin.zonedSchedule(
          0,
          'Alarm Title',
          'Alarm Body',
          //tz.TZDateTime.from(notificationTime, tz.local),
          //scheduledTZTime,
          //TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
          notifTime,
          notificationDetails(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  void scheduleAlarm_2(DateTime notificationTime) async {
    log("scheduleAlarm_2");
    initializeTimezoneForApp();

    var notifTime = _convertTime(notificationTime);
    log("notifTime=$notifTime");

    await notificationsPlugin.zonedSchedule(
      0,
      'Alarm Title',
      'Alarm Body',
      notifTime,
      notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _convertTime(DateTime myTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      myTime.year,
      myTime.month,
      myTime.day,
      myTime.hour,
      myTime.minute,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(seconds: 5));
    }
    return scheduleDate;
  }

  List<DateTime> calculateNotificationTimes(Reveil alarm) {
    final List<DateTime> notificationTimes = [];
//    const interval = Duration(hours: 4);
    const interval = Duration(minutes: 1);
    //const interval = Duration(hours: 5);
    const maximumDurationInMinutes = 10;

    DateTime alarmStartTime =
        DateFormat('dd/MM/yyyy HH:mm').parse(alarm.startDate.toString());
    DateTime alarmEndTime =
        DateFormat('dd/MM/yyyy HH:mm').parse(alarm.endDate.toString());
    DateTime currentNotificationTime = DateTime.now();

    log("alarmStartTime=$alarmStartTime");
    log("alarmEndTime=$alarmEndTime");
    log("currentNotificationTime=$currentNotificationTime");
    // while (DateTime.now().isBefore(alarmEndTime)) {
    //   notificationTimes.add(currentNotificationTime);
    //   currentNotificationTime = currentNotificationTime.add(interval);
    // }

    // Limit the number of notifications based on the difference between start and end dates
    while (currentNotificationTime.isBefore(alarmEndTime)
        //&& currentNotificationTime.difference(alarmStartTime).inMinutes <= maximumDurationInMinutes
        ) {
      notificationTimes.add(currentNotificationTime);
      currentNotificationTime = currentNotificationTime.add(interval);
    }

    return notificationTimes;
  }

  static Future<void> initializeTimezoneForApp() async {
    var tunisia = getLocation('Africa/Tunis');
    setLocalLocation(tunisia);
  }
}
