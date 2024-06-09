import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:book_bridge/controllers/notification_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';




class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
    const AndroidInitializationSettings('@drawable/logo');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        _handleNotificationResponse(notificationResponse);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleForegroundMessage(message, flutterLocalNotificationsPlugin);
    });
  }

  static void _handleNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload!.isNotEmpty) {
      final Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
      int? orderId = int.tryParse(data['order_id']);
      String? type = data['type'];

      try {
        Get.toNamed("/notification");
      } catch (e) {
        return;
      }
    }
  }

  static void _handleForegroundMessage(RemoteMessage message,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    if (kDebugMode) {
      log("onMessage: ${message.notification!.title}/${message.notification!.body}");
    }
    showNotification(message, flutterLocalNotificationsPlugin);
  }

  static Future<void> showNotification(
      RemoteMessage message, FlutterLocalNotificationsPlugin? fln) async {
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    String? orderID = message.notification?.titleLocKey;
    String? image = _getImageUrl(message);
    String? type = message.data['type'];

    Map<String, String> payloadData = {
      'title': '$title',
      'body': '$body',
      'order_id': '$orderID',
      'image': '$image',
      'type': '$type',
      'read': 'false',
    };

    try {
      if (image != null && image.isNotEmpty) {
        await showBigPictureNotificationHiddenLargeIcon(payloadData, fln!);
      } else {
        await showBigTextNotification(payloadData, fln!);
      }
      NotificationController.to.increment();
    } catch (e) {
      await showBigTextNotification(payloadData, fln!);
      NotificationController.to.increment();
    }
  }

  static String? _getImageUrl(RemoteMessage message) {
    if (Platform.isAndroid) {
      return message.notification?.android?.imageUrl;
    } else if (Platform.isIOS) {
      return message.notification?.apple?.imageUrl;
    }
    return null;
  }

  static Future<void> showBigTextNotification(
      Map<String, String> data, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      data['body']!,
      htmlFormatBigText: true,
      contentTitle: data['title'],
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      "bookBridge", "bookBridge", importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, data['title'], data['body'], platformChannelSpecifics,
        payload: jsonEncode(data));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      Map<String, String> data,
      FlutterLocalNotificationsPlugin fln,
      ) async {
    final String largeIconPath =
    await _downloadAndSaveFile(data['image']!, 'largeIcon');
    final String bigPicturePath =
    await _downloadAndSaveFile(data['image']!, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: data['title'],
      htmlFormatContentTitle: true,
      summaryText: data['body'],
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      "bookBridge", "bookBridge",
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, data['title'], data['body'], platformChannelSpecifics,
        payload: jsonEncode(data));
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    log("onBackground: ${message.notification!.title}/${message.notification!.body}");
  }
}
