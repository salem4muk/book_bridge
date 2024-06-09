import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  static Future<Response> login(Map creds) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/login',
        data: creds,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> register(Map creds) async {
    try {
      final response = await ApiService.dio.post(
        '/user/accounts/registerUserAccount',
        data: creds,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> forgotPassword(Map data) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/ForgotPassword',
        data: data,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> resetPassword(Map data) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/ResetPassword',
        data: data,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> sendVerificationCodeForPhone(Map data, String token) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/sendVerificationCodeForPhone',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: data,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> verifyCode(Map data, String token) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/verifyPhoneNumber',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: data,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> verifyCodeEmail(Map data) async {
    try {
      final response = await ApiService.dio.post(
        '/shared/accounts/checkTokenOfResetPassword',
        data: data,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> updateEmail(Map data, String token) async {
    try {
      final response = await ApiService.dio.put(
        '/shared/accounts/updateEmail',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'password': data['password'], 'newEmail': data['newEmail']},
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> updatePassword(Map data, String token) async {
    try {
      final response = await ApiService.dio.put(
        '/shared/accounts/UpdatePassword',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: {'oldPassword': data['oldPassword'], 'newPassword': data['newPassword']},
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> getUserInformation(String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/accounts/getUserInformation',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> updateFcmToken(String fcmToken, String token) async {
    try {
      final response = await ApiService.dio.post(
        '/notifications/updateFcmToken',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters : {'fcmToken': fcmToken},
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> logout(String token) async {
    try {
      final response = await ApiService.dio.delete(
        '/shared/accounts/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
