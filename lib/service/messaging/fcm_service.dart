import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  developer.log(
    'BACKGROUND MESSAGE: ${message.notification?.title}',
    name: 'FCM',
  );
}

class FcmService {
  final FirebaseMessaging messaging;
  final LocalNotificationService localNotifications;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  bool _isInitializing = false;
  bool _isInitialized = false;

  FcmService({required this.messaging, required this.localNotifications});

  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      await messaging.requestPermission(alert: true, badge: true, sound: true);

      try {
        await localNotifications.initialize();
      } catch (error, stackTrace) {
        developer.log(
          'Local notification setup failed',
          name: 'FCM',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final token = await messaging.getToken();
      if (token != null) {
        developer.log('FCM token received: $token', name: 'FCM');
      }

      _tokenSubscription = messaging.onTokenRefresh.listen((token) {
        developer.log('FCM token refreshed: $token', name: 'FCM');
      });

      _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification != null) {
          localNotifications.show(
            title: notification.title ?? '',
            body: notification.body ?? '',
          );
        }
      });

      _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
        message,
      ) {
        developer.log('Notification tapped: ${message.data}', name: 'FCM');
      });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        developer.log(
          'App opened from notification: ${initialMessage.data}',
          name: 'FCM',
        );
      }

      _isInitialized = true;
    } catch (error, stackTrace) {
      developer.log(
        'FCM initialization failed; it can be retried',
        name: 'FCM',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isInitializing = false;
    }
  }

  Future<String?> getToken() => messaging.getToken();

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    await _tokenSubscription?.cancel();
    await _openedAppSubscription?.cancel();
  }
}
