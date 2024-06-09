import 'dart:developer';
import 'package:get/get.dart';
import 'package:book_bridge/models/city_model.dart';
import 'package:book_bridge/services/city_service.dart';
import '../helper/dialog_helper.dart';

class CityController extends GetxController {
  var citiesList = List<City>.empty().obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getResidentialQuarterAndItsPoints();
  }

  Future<void> getResidentialQuarterAndItsPoints() async {
    isLoading(true);
    try {
      var response = await CityService.getResidentialQuarterAndItsPoints();
      if (response.statusCode == 200) {
        var data = response.data as List<dynamic>;
        List<City> loadedCities = data.map((json) => City.fromJson(json)).toList();
        citiesList.addAll(loadedCities);
      } else {
        DialogHelper.showDialog(response.data['message']);
      }
    } catch (e) {
      log('Failed to load cities: $e');
      // Get.snackbar('Error', 'Failed to load cities');
    } finally {
      isLoading(false);
    }
  }
}
