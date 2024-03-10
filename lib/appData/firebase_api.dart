import 'dart:async';
import 'dart:convert';

import 'package:blinq_sol/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_important_channel',
    'High Important Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          )
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const InitializationSettings settings =  InitializationSettings(
      android: android,
    );

    final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
    const String navigationActionId = 'id_3';

    await _localNotifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse){
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            final message = notificationResponse.payload;
            handleMessage(RemoteMessage.fromMap(jsonDecode(message!)));
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
              final message = notificationResponse.payload;
              handleMessage(RemoteMessage.fromMap(jsonDecode(message!)));
            }
            break;
        }
      }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
}

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
    initPushNotifications();
  }

  Future<void> handleMessage(RemoteMessage? message)async {
    if(message == null) return;

    print('hm Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
    navigatorKey.currentState?.pushReplacementNamed('/notification-screen', arguments: message);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token : $fcmToken');

    // Create storage
    const storage = FlutterSecureStorage();
    // Write token
    await storage.write(key: 'fcmToken', value: fcmToken);

    initPushNotifications();
    initLocalNotifications();
  }
}