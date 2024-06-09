import 'dart:convert';
import 'dart:io';
import 'package:book_bridge/constants.dart';
import 'package:book_bridge/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DonationService {

  static Future<Response> getLastDonations(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getLastDonations',
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

  static Future<Response> searchAvailableBookPackages(int page, String token,Map data) async {
    try {
      final response = await ApiService.dio.post(
        '/user/bookDonations/searchAvailableBookPackages',
        queryParameters: {'page': page},
        data: data,
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

  static Future<Response> getUndeliveredDonationsForUser(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getUndeliveredDonationsForUser',
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

  static Future<Response> getWaitedDonationsForUser(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getWaitedDonationsForUser',
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

  static Future<Response> getDeliveredDonationsForUser(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getDeliveredDonationsForUser',
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

  static Future<Response> getRejectedDonationsForUser(int page, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/getRejectedDonationsForUser',
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

  static Future<Response> getDonations(int id, String token) async {
    try {
      final response = await ApiService.dio.get(
        '/user/bookDonations/get/$id',
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

  static Future<Response> bookingDonations(int id, String token) async {
    try {
      final response = await ApiService.dio.put(
        '/user/bookDonations/book/$id',
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

  static Future<dynamic> addDonation({
    required int exchangePointId,
    required String level,
    required String semester,
    required String description,
    required String donorName,
    required List<File> images,
    required String token,
}) async {
    try {
      const String apiUrl = '$baseUrlApi/user/bookDonations/store';
      final Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields.addAll({
        'exchangePoint_id': '$exchangePointId',
        'level': level,
        'semester': semester,
        'description': description,
        'donorName': donorName
      });
      for (File image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          image.path,
        ));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String jsonString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(jsonString);
        return jsonResponse;
      }
      else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      return Future.error(e);
    }
  }


  static Future<dynamic> editDonation({
    required int id,
    required int exchangePointId,
    required String level,
    required String semester,
    required String description,
    required String donorName,
    required List<File> images,
    required List<int> deletedImages,
    required String token,
  }) async {
    try {
      // Step 1: Delete specified images
      if (deletedImages.isNotEmpty) {
        for (int id in deletedImages) {
          final deleteImageResult = await deleteImage(id, token);
          if (deleteImageResult.data['status'] == 'fail') {
            return deleteImageResult;
          }
        }
      }

      // Step 2: Update donation details
      final response = await ApiService.dio.put(
        '/user/bookDonations/update/$id',
        queryParameters: {
          'level': level,
          'semester': semester,
          'description': description,
          'donorName': donorName,
          'exchangePoint_id': exchangePointId.toString(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        // Step 3: Add new images if present
        if (images.isNotEmpty) {
          final addImageResult = await addImageNew(id, token, images);
          if (addImageResult['status'] == 'fail') {
            return addImageResult;
          }
        }

        return response;
      } else {
        if (kDebugMode) {
          print('Failed to update donation: ${response.statusMessage}');
        }
        return response;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

// Delete image function
  static Future<dynamic> deleteImage(int id, String token) async {
    try {
      final response = await ApiService.dio.delete(
        '/images/destroy/$id',
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

// Add new images function
  static Future<dynamic> addImageNew(int bookDonationId, String token, List<File> images) async {
    try {
      const String apiUrl = '$baseUrlApi/images/uploadImage';
      final Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['bookDonation_id'] = bookDonationId.toString();

      for (File image in images) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String jsonString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(jsonString);
        return jsonResponse;
      }
      else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> deleteDonation(int id, String token) async{
    try {
      final response = await ApiService.dio.delete(
        '/user/bookDonations/destroy/$id',
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


  static Future<dynamic> cancelReservationByDonor(int beneficiaryId, String token) async{
    try {
      final response = await ApiService.dio.put(
        '/user/bookDonations/cancelReservationByDonor/$beneficiaryId',
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
