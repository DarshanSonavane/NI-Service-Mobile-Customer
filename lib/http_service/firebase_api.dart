import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ni_service/http_service/services.dart';
import 'package:ni_service/model/FCMDetails/RequestFCMKeyDetails.dart';
import '../Utils/Constants.dart';
import '../Screens/NotificationDisplayScreen.dart';
import '../main.dart';
import '../widgets/SharedPreferencesManager.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final sharedPreferences = SharedPreferencesManager.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseApi() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/nilogobackground');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationResponse(response);
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse response) {
        _handleNotificationResponse(response);
      },
    );
  }

  Future<void> initNotifications(BuildContext context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final fcmToken = await _firebaseMessaging.getToken();
      print("FCMTOKEN $fcmToken");
      if (fcmToken != null) {
        RequestFCMKeyDetails requestFCMKeyDetails = RequestFCMKeyDetails();
        requestFCMKeyDetails.customerId = sharedPreferences?.getString(CUSTOMERID);
        requestFCMKeyDetails.deviceId = await getDeviceId();
        requestFCMKeyDetails.fcmKey = fcmToken;
        await sendTokenToServer(requestFCMKeyDetails);
      }
      initPushNotifications(context);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showNotification(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: '@drawable/nilogobackground',
      );

      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: message.data['payload'],
      );
    }
  }


  // Future<void> initNotifications(BuildContext context) async {
  //   await _firebaseMessaging.requestPermission();
  //   final fcmToken = await _firebaseMessaging.getToken();
  //   print("FCMTOKEN $fcmToken");
  //   if (fcmToken != null) {
  //     RequestFCMKeyDetails requestFCMKeyDetails = RequestFCMKeyDetails();
  //     requestFCMKeyDetails.customerId =
  //         sharedPreferences?.getString(CUSTOMERID);
  //     requestFCMKeyDetails.deviceId = await getDeviceId();
  //     requestFCMKeyDetails.fcmKey = fcmToken;
  //     await sendTokenToServer(requestFCMKeyDetails);
  //   }
  //   initPushNotifications(context);
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     _showNotification(message);
  //   });
  // }

  // void _showNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     message.notification.hashCode,
  //     message.notification?.title,
  //     message.notification?.body,
  //     platformChannelSpecifics,
  //     payload: message.data['payload'],
  //   );
  // }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Notificationdisplayscreen.routeName,
            (Route<dynamic> route) => route.isFirst,
      );
    }
  }

  void handleMessage(RemoteMessage? message, BuildContext context) {
    print("Meesage ${message?.notification?.body}");
    if (message == null) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Notificationdisplayscreen.routeName,
      (route) => route.isFirst,
    );
  }

  Future initPushNotifications(BuildContext context) async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message, context);
    });
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor!; // Unique ID on iOS
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
