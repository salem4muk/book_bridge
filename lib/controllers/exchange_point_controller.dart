import 'dart:developer';

import 'package:get/get.dart';

import '../models/exchange_point.dart';
import '../services/exchange_point_service.dart';

class ExchangePointController extends GetxController {
  var exchangePointList = <ExchangePoint>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getExchangePoints();
  }

  Future<List<ExchangePoint>> getExchangePoints() async {
    isLoading(true);
    try {
      var response = await ExchangePointService.getExchangePoints();
      if (response.statusCode == 200) {
        var data = response.data as List;
        List<ExchangePoint> loadedExchangePoints = data.map((json) => ExchangePoint.fromJson(json)).toList();
        exchangePointList.addAll(loadedExchangePoints);
        return loadedExchangePoints;
      } else {
        Get.snackbar('Error', response.data['message'] ?? 'Unknown error');
        return [];
      }
    } catch (e) {
      log('Failed to load exchange points: $e');
      Get.snackbar('Error', 'Failed to load exchange points');
      return [];
    } finally {
      isLoading(false);
    }
  }
}
