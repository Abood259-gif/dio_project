
import 'package:dio_project/app_routs.dart';
import 'package:dio_project/firebase_options.dart';
import 'package:dio_project/provider/fcm_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // You must initialize Firebase in this background isolate before doing anything else
  await Firebase.initializeApp(); 
  debugPrint('BACKGROUND MESSAGE: ${message.notification?.title}');
}
Future<void> main() async {

await Supabase.initialize(
   url: 'https://dgzbsqnuheqeuzqhwkxh.supabase.co',
  publishableKey: 'sb_publishable_9oN1KvSyyEpW_rP5yNW-kA_JwySraXi',
  );
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

 final container = ProviderContainer();

  // Now we CAN read fcmServiceProvider, because `container` gives us
  // the same dependency graph the widget tree will use afterward.
  await container.read(fcmServiceProvider).initialize();


  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
