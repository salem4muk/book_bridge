import 'dart:developer';

import 'package:book_bridge/models/failed_reservation.dart';
import 'package:book_bridge/models/reservation_model.dart';
import 'package:book_bridge/models/waited_reservation_to_collect.dart';
import 'package:book_bridge/services/reservation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helper/dialog_helper.dart';
import '../services/donation_service.dart';

class ReservationController extends GetxController {
  var isLoading = false.obs;
  var isLoadingDelete = false.obs;
  var waitedReservationsToReceive = List<Reservations>.empty().obs;
  var deliveredReservations = List<Reservations>.empty().obs;
  var waitedReservationsToCollect =
      List<WaitedReservationsToCollect>.empty().obs;
  var failedReservations = List<FailedReservations>.empty().obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Reservations>> getWaitedReservationsToReceive(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.getWaitedReservationsToReceive(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<Reservations> loadedReservations =
            data.map((json) => Reservations.fromJson(json)).toList();
        waitedReservationsToReceive.addAll(loadedReservations);
        return loadedReservations;
      } else {
        DialogHelper.showDialog(response.data['message']);

        return [];
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<List<WaitedReservationsToCollect>> getWaitedReservationsToCollect(
      int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.getWaitedReservationsToCollect(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<WaitedReservationsToCollect> loadedWaitedReservationsToCollect =
            data
                .map((json) => WaitedReservationsToCollect.fromJson(json))
                .toList();
        waitedReservationsToCollect.addAll(loadedWaitedReservationsToCollect);
        return loadedWaitedReservationsToCollect;
      } else {
        DialogHelper.showDialog(response.data['message']);

        return [];
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<List<Reservations>> getDeliveredReservations(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.getDeliveredReservations(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<Reservations> loadedDeliveredReservations =
            data.map((json) => Reservations.fromJson(json)).toList();
        deliveredReservations.addAll(loadedDeliveredReservations);
        return loadedDeliveredReservations;
      } else {
        DialogHelper.showDialog(response.data['message']);

        return [];
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<List<FailedReservations>> getFailedReservations(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.getFailedReservations(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<FailedReservations> loadedFailedReservations =
            data.map((json) => FailedReservations.fromJson(json)).toList();
        failedReservations.addAll(loadedFailedReservations);
        return loadedFailedReservations;
      } else {
        DialogHelper.showDialog(response.data['message']);

        return [];
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<bool> cancelReservationNotInPointByBeneficiary(
      int beneficiaryId) async {
    isLoadingDelete(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.cancelReservationNotInPointByBeneficiary(
              beneficiaryId, token);
      if (response.data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return false;
    } finally {
      isLoadingDelete(false);
    }
  }

  Future<bool> cancelReservationInPointByBeneficiary(int beneficiaryId) async {
    isLoadingDelete(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await ReservationService.cancelReservationInPointByBeneficiary(
              beneficiaryId, token);
      if (response.data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return false;
    } finally {
      isLoadingDelete(false);
    }
  }
}
