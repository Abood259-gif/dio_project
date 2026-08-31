


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio_project/service/messaging/fcm_service.dart';
import 'package:dio_project/service/messaging/local_notification_service.dart';

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref.watch(localNotificationServiceProvider));
});