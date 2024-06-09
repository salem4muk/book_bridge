import 'dart:convert';
import 'dart:io';
import 'package:book_bridge/constants.dart';
import 'package:book_bridge/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ReservationService {





  static Future<Response> getWaitedReservationsToReceive(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getWaitedReservationsToReceive',
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

  static Future<Response> getWaitedReservationsToCollect(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getWaitedReservationsToCollect',
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

  static Future<Response> getDeliveredReservations(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getDeliveredReservations',
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

  static Future<Response> getFailedReservations(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getFailedReservations',
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



  static Future<dynamic> cancelReservationNotInPointByBeneficiary(int beneficiaryId, String token) async{
    try {
      final response = await ApiService.dio.put(
        '/user/bookDonations/cancelReservationNotInPointByBeneficiary/$beneficiaryId',
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

  static Future<dynamic> cancelReservationInPointByBeneficiary(int beneficiaryId, String token) async{
    try {
      final response = await ApiService.dio.put(
        '/user/bookDonations/cancelReservationInPointByBeneficiary/$beneficiaryId',
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
