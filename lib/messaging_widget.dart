import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_demo/first.dart';
import 'package:notification_demo/second.dart';

class MessageWidget extends StatefulWidget {
  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
        // _serialiseAndNavigate(message);

        //    _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _firebaseMessaging.onTokenRefresh;
        print("onLaunch: $message");
        _serialiseAndNavigate(message);
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _firebaseMessaging.onTokenRefresh;
        print("onResume: $message");
        _serialiseAndNavigate(message);
        //  _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform,
        payload: message['data']['view']);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    if (payload != null) {
      // Navigate to the create post view
      if (payload == 'secnd_screen') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => First()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Second()));
      }
    }
    // showDialog(
    //   context: context,
    //   builder: (_) => new AlertDialog(
    //     title: new Text('Notification'),
    //     content: new Text('$payload'),
    //   ),
    // );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];
    print(message);
    print(message['data']);
    print("view name is $view");
    if (view != null) {
      // Navigate to the create post view
      if (view == 'secnd_screen') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => First()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Second()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('HI'),
        ),
      ),
    );
  }
}
