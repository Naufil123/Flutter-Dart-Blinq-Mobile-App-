
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteMessage? message = ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${message?.notification?.title}'),
            Text('${message?.notification?.body}'),
            Text('${message?.data}')
          ],
        ),
      ),
    );
  }
}