import 'package:book_bridge/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../constants.dart';
import '../widgets/custom_follow_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with AutomaticKeepAliveClientMixin {
  final NotificationController _notificationController = Get.find<NotificationController>();
  List<dynamic> notifications = [];
  bool isLoading = true;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreNotifications();
      }
    });
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      isLoading = true;
    });
    _notificationController.notifications.clear();
    List<dynamic> fetchedNotifications = await _notificationController.getNotification(currentPage);
    setState(() {
      notifications.addAll(fetchedNotifications);
      isLoading = false;
    });
  }

  void _loadMoreNotifications() {
    if (!isLoading) {
      setState(() {
        currentPage++;
      });
      _fetchNotifications();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      _notificationController.reset();
    });
    super.build(context); // Needed for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        backgroundColor: form,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "الأشعارات",
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: textColor),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20).w,
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return CustomFollowNotification(
                  title: notification.title,
                  description: notification.description,
                  createdAt: notification.createdAt,
                );
              },
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
