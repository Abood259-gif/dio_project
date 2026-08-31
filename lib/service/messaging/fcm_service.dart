


import 'package:dio_project/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';

/// Must be a TOP-LEVEL (or static) function — not a class method —
/// because Android runs this in a separate isolate when the app is
/// terminated, and it needs to find this function without an object instance.


class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications;

  FcmService(this._localNotifications);

  Future<void> initialize() async {
    // 1. Ask the user for permission (Android 13+, and required on iOS too)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Register the background/terminated handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. FOREGROUND: app is open right now — manually show a banner
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }
    });

    // 4. User taps a notification while app was in BACKGROUND (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped (from background): ${message.data}');
      // e.g. navigate to a specific screen based on message.data
    });

    // 5. App was fully TERMINATED and opened by tapping a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state: ${initialMessage.data}');
      // e.g. navigate to a specific screen based on initialMessage.data
    }
  }

  Future<String?> getToken() => _messaging.getToken();
}