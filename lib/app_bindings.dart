import 'package:book_bridge/controllers/city_controller.dart';
import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:book_bridge/controllers/notification_controller.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/reservation_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<DonationController>(() => DonationController());
    Get.lazyPut<CityController>(() => CityController());
    Get.lazyPut<ReservationController>(() => ReservationController());
    Get.lazyPut<NotificationController>(() => NotificationController());

    Get.put(AuthController());
    Get.put(CityController());
    Get.put(DonationController());
    Get.put(NotificationController());
  }
}
