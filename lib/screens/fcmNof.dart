import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmNotification extends StatefulWidget {
  const FcmNotification({super.key});

  @override
  State<FcmNotification> createState() => _FcmNotificationState();
}

class _FcmNotificationState extends State<FcmNotification> {
  late FirebaseMessaging _messaging;
  String? _token;
  String _messageText = 'No notifications yet';

  @override
  void initState() {
    super.initState();
    setupFirebase();
  }

  Future<void> setupFirebase() async {
    _messaging = FirebaseMessaging.instance;

    // Request notifications permission (mandatory for iOS apps)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the FCM token for the device
    _token = await _messaging.getToken(); // Corrected from _message.getToken()
    print('FCM token: $_token');

    // Save the token to your backend if needed
    saveTokenToDatabase(_token);

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received foreground notification: ${message.notification?.title}");
      setState(() {
        _messageText = message.notification?.body ?? 'No message content';
      });
    });

    // Handle background notifications (when app is in background and user taps the notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened app: ${message.notification?.title}');
      setState(() {
        _messageText = "App opened from notification: ${message.notification?.body}";
      });
    });

    // Handle terminated notifications (when app is completely closed and user taps the notification)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("App launched from notification: ${initialMessage.notification?.title}");
      setState(() {
        _messageText = "App launched from notification: ${initialMessage.notification?.body}";
      });
    }
  }

  // Save the token to database (e.g., Node.js backend) if required
  void saveTokenToDatabase(String? token) {
    // Implement sending token to your backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Notifications'),
      ),
      body: Center(
        child: Text(_messageText),
      ),
    );
  }
}
