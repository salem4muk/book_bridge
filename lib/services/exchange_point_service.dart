import 'package:dio/dio.dart';
import 'api_service.dart';

class ExchangePointService {
  static Future<Response> getExchangePoints() async {
    try {
      final response = await ApiService.dio.get('/exchangePoints/getExchangePoints');
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
