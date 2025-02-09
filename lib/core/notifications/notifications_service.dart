import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones(); // Required for scheduling

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification clicked!");
      },
    );
  }

  // Instant notification 
  static Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_notification_channel',
      'Instant Notification',
      channelDescription: 'Displays notifications instantly',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Unique notification ID
      'Test Notification',
      'This is a test notification!',
      details,
    );
  }

  //notif for 1 min
 static Future<void> scheduleNotification() async {
  tz.initializeTimeZones();

  final location = tz.getLocation('Asia/Kolkata');
  tz.setLocalLocation(location); // Ensure local time zone is set globally

  final now = DateTime.now();
  final nowTZ = tz.TZDateTime.now(location);
  final scheduledTime = nowTZ.add(Duration(seconds: 5));

  print("📅 System Time: $now (Device Time)");
  print("⏰ Kolkata Time: $nowTZ (${nowTZ.timeZoneName})");
  print("🚀 Scheduling notification at: $scheduledTime");

  await _notificationsPlugin.zonedSchedule(
    1,
    'Scheduled Reminder',
    'Don’t forget to log your expenses!',
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_notification_channel',
        'Scheduled Notification',
        channelDescription: 'Scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

  // Schedule notification every day at 10 PM
  static Future<void> scheduleDailyNotificationAt10PM() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      3, // 🔥 10 PM
      21,
    );

    // If it's already past 10 PM today, schedule for tomorrow
    final nextNotificationTime =
        scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime;

    await _notificationsPlugin.zonedSchedule(
      2, // Unique ID
      'Daily Reminder',
      'It’s 10 PM! Don’t forget to check your expenses.',
      nextNotificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notifications',
          channelDescription: 'Daily 10 PM Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time, // Ensures it repeats daily
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  //  Cancel notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
