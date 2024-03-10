import 'package:blinq_sol/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  initPushNotifications();
}

Future<void> handleMessage(RemoteMessage? message)async {
  if(message == null) return;

  navigatorKey.currentState?.pushReplacementNamed('/notification-screen', arguments: message);
}

Future initPushNotifications() async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await handleMessage(message);
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await handleMessage(message);
  });
  FirebaseMessaging.onBackgroundMessage((message) => handleBackgroundMessage(message));
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token : $fcmToken');

    // Create storage
    const storage = FlutterSecureStorage();
    // Write token
    await storage.write(key: 'fcmToken', value: fcmToken);

    FirebaseMessaging.onBackgroundMessage((message) => handleBackgroundMessage(message));
  }
}