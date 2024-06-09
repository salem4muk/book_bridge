import 'package:book_bridge/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final NotificationController _notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: form,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: Stack(
        textDirection: TextDirection.rtl,
        children: [
          IconButton(
            onPressed: () {
              Get.toNamed("/notification");
            },
            icon: const Icon(
              IconlyBroken.notification,
              color: primary,
              size: 25,
            ),
          ),
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
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: textColor),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            IconlyBroken.arrow_right_2,
            color: primary,
            size: 29,
          ),
        ),
      ],
    );
  }
}
