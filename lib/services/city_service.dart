import 'package:dio/dio.dart';
import 'api_service.dart';

class CityService {
  static Future<Response> getCities() async {
    try {
      final response = await ApiService.dio.get('/user/residentialQuarter/getResidentialQuarter');
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> getResidentialQuarterAndItsPoints() async {
    try {
      final response = await ApiService.dio.get('/user/residentialQuarter/getResidentialQuarterAndItsPoints');
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
