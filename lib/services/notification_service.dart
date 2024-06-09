import 'package:dio/dio.dart';

import 'api_service.dart';

class NotificationService {

  static Future<Response> getNotification(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/notifications/get',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}