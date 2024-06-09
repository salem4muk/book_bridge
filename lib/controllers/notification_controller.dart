import 'dart:developer';

import 'package:book_bridge/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helper/dialog_helper.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  var counter = 0.obs;
  var isLoading = false.obs;
  var notifications = List<NotificationModel>.empty().obs;
  final box = GetStorage();


  @override
  void onInit() {
    super.onInit();
    _loadCounter();
  }

  void increment() {
    counter++;
    _saveCounter();
    update();
  }

  void decrement() {
    if (counter > 0) {
      counter--;
      _saveCounter();
      update();
    }
  }

  void reset() {
    counter.value = 0;
    _saveCounter();
    update();
  }


  Future<void> _loadCounter() async {
    counter.value = box.read('counter') ?? 0;
  }

  Future<void> _saveCounter() async {
    await box.write('counter', counter.value);
  }

  Future<List<NotificationModel>> getNotification(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response = await NotificationService.getNotification(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<NotificationModel> loadedNotifications =
        data.map((json) => NotificationModel.fromJson(json)).toList();
        notifications.addAll(loadedNotifications);
        return loadedNotifications;
      } else {
        DialogHelper.showDialog(response.data['message']);
        return [];
      }
    } catch (e) {
      log('Failed to load notifications $e');
      return [];
    } finally {
      isLoading(false);
    }
  }
}
