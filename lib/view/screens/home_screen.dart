import 'package:book_bridge/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';
import 'about_screen.dart';
import 'taps/home_tap.dart';
import 'taps/more_tap.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  List item = [];
  final NotificationController _notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: form,
        // hide back button
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            },
            icon: const Icon(
              IconlyBroken.info_square,
              color: primary,
              size: 25,
            )),
        titleSpacing: -7,
        title: Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed("/notification");
                },
                icon: const Icon(
                  IconlyBroken.notification,
                  color: primary,
                  size: 25,
                )),
            Positioned(
              right: 6,
              top: 6,
              child: Obx(() {
                if (_notificationController.counter.value > 0) {
                  return CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      '${_notificationController.counter}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // لا عرض عندما counter صفر
                }
              }),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.shortestSide / 2.2),
            // 50% = 0.5, half of that for each side
            child: Image(
              image: const AssetImage("assets/Img/logo.png"),
              width: 30.w,
            ),
          )
        ],
      ),

      bottomNavigationBar: bottomNavigationBar(),
      // we put the floatingAction Button in method
      floatingActionButton: floatingActionButton(),
      //here is the location of floatingActionButton
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      persistentFooterAlignment: AlignmentDirectional.center,
      body: taps[_currentIndex],
    );
  }

  // list of taps
  List<Widget> taps = const [
    MoreTap(),
    HomeTap(),
  ];

  bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: primary,
      backgroundColor: form,
      elevation: 0,
      onTap: (int index) {
        if (index == 0) {
          setState(() {
            _currentIndex = index;
          });
        } else if (index == 1) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      unselectedItemColor: secondaryText,
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }

  // List of item
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(IconlyBroken.info_circle), label: "المزيد"),
    BottomNavigationBarItem(icon: Icon(IconlyBroken.home), label: "الرئيسية"),
  ];

  // floatingActionButton method format
  floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed('/add_donation_screen');
      },
      backgroundColor: primary,
      elevation: 0,
      child: const Icon(
        IconlyBroken.plus,
        size: 30,
      ),
    );
  }
}
