import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/auth_controller.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      // Ensure you have a reference to AuthController
      final AuthController authController = Get.find<AuthController>();
      authController.checkLoginStatus();
      requestPermission();
      var fcmToken = await FirebaseMessaging.instance.getToken();
      authController.box.write('fcmToken', fcmToken);
    });

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.shortestSide / 3)
                .h,
            child: Image.asset(
              "assets/Img/logo.png",
              width: 150,
            ),
          ),
          SizedBox(
            height: 150.h,
          ),
          const SpinKitThreeBounce(
            color: primary,
            size: 30.0,
          ),
        ],
      ),
    );
  }


  void requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }
}
