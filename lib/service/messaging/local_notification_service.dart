import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('ic_notification');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _plugin.initialize(settings: initSettings);

    // Explicitly create the high-importance channel on the Android device
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fcm_default_channel', // Channel ID for Firebase Console & AndroidManifest
      'General Notifications',
      description: 'Used for important notification pop-ups',
      importance: Importance.max, // High/Max importance enables heads-up banner
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> show({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_default_channel',
      'General Notifications',
      icon: 'ic_notification',
      importance: Importance.max, // Changed from high to max
      priority: Priority.high,
    );
    
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
    id:  DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title:  title,
     body: body,
     notificationDetails: notificationDetails,
    );
  }
}