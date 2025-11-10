import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    print("show notification is called");
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Drama Updates',
      channelDescription: 'Notifications for new drama uploads',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);
    // await _notifications.show(
    //   DateTime.now().millisecondsSinceEpoch ~/ 1000, // 👈 Unique ID every time
    //   title,
    //   body,
    //   platformDetails,
    // );

    await _notifications.show(0, title, body, platformDetails);
  }
}

