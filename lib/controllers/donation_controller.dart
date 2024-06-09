import 'dart:developer';
import 'dart:io';

import 'package:book_bridge/models/delivered_donation.dart';
import 'package:book_bridge/models/donation_model.dart';
import 'package:book_bridge/models/rejected_donation.dart';
import 'package:book_bridge/models/undelivered_donation.dart';
import 'package:book_bridge/models/waited_donation.dart';
import 'package:book_bridge/services/donation_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helper/dialog_helper.dart';

class DonationController extends GetxController {
  var isLoading = false.obs;
  var isLoadingDelete = false.obs;
  var donations = List<Donation>.empty().obs;
  var undeliveredDonations = List<UndeliveredDonations>.empty().obs;
  var waitedDonations = List<WaitedDonations>.empty().obs;
  var deliveredDonations = List<DeliveredDonations>.empty().obs;
  var rejectedDonations = List<RejectedDonations>.empty().obs;
  final box = GetStorage();

  Future<List<Donation>> getLastDonations(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.getLastDonations(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<Donation> loadedDonations =
            data.map((json) => Donation.fromJson(json)).toList();
        donations.addAll(
            loadedDonations); // إضافة التبرعات الجديدة إلى القائمة الحالية
        return loadedDonations;
      } else {
        DialogHelper.showDialog(response.data['message']);
        return [];
      }
    } catch (e) {
      log('Failed to load donations $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<List<UndeliveredDonations>> getUndeliveredDonations(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.getUndeliveredDonationsForUser(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<UndeliveredDonations> loadedDonations =
            data.map((json) => UndeliveredDonations.fromJson(json)).toList();
        undeliveredDonations.addAll(loadedDonations);
        return loadedDonations;
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

  Future<List<WaitedDonations>> getWaitedDonationsForUser(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.getUndeliveredDonationsForUser(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<WaitedDonations> loadedWaitedDonations =
            data.map((json) => WaitedDonations.fromJson(json)).toList();
        waitedDonations.addAll(loadedWaitedDonations);
        return loadedWaitedDonations;
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

  Future<List<DeliveredDonations>> getDeliveredDonationsForUser(
      int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.getDeliveredDonationsForUser(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<DeliveredDonations> loadedDeliveredDonations =
            data.map((json) => DeliveredDonations.fromJson(json)).toList();
        deliveredDonations.addAll(loadedDeliveredDonations);
        return loadedDeliveredDonations;
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

  Future<List<RejectedDonations>> getRejectedDonationsForUser(int page) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.getRejectedDonationsForUser(page, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<RejectedDonations> loadedRejectedDonations =
            data.map((json) => RejectedDonations.fromJson(json)).toList();
        rejectedDonations.addAll(loadedRejectedDonations);
        return loadedRejectedDonations;
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

  Future<List<Donation>> searchAvailableBookPackages(int page, Map data) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.searchAvailableBookPackages(page, token, data);
      if (response.data['status'] == 'success') {
        var data = response.data['data']['data'] as List;
        List<Donation> loadedDonations =
            data.map((json) => Donation.fromJson(json)).toList();
        donations.addAll(
            loadedDonations); // إضافة التبرعات الجديدة إلى القائمة الحالية
        return loadedDonations;
      } else {
        DialogHelper.showDialog(response.data['message']);
        return [];
      }
    } catch (e) {
      log('Failed to load donations $e');
      return [];
    } finally {
      isLoading(false);
    }
  }

  Future<Donation?> getDonation(int id) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.getDonations(id, token);
      if (response.data['status'] == 'success') {
        var data = response.data['data'];
        // Parse the single donation object
        Donation loadedDonation = Donation.fromJson(data);
        // Add the new donation to the list of donations
        donations.add(loadedDonation);
        return loadedDonation;
      } else {
        DialogHelper.showDialog(response.data['message']);
        return null;
      }
    } catch (e) {
      log('Failed to load donations: $e');
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> bookingDonations(int id) async {
    isLoadingDelete(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.bookingDonations(id, token);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog("تم طلب الحزمة بنجاح");
      } else {
        DialogHelper.showDialog(response.data['message']);
      }
    } catch (e) {
      log('Failed to load donations: $e');
    } finally {
      isLoadingDelete(false);
    }
  }

  Future<bool> addDonation({
    required int exchangePointId,
    required String level,
    required String semester,
    required String description,
    required String donorName,
    required List<File> images,
  }) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.addDonation(
        exchangePointId: exchangePointId,
        level: level,
        semester: semester,
        description: description,
        donorName: donorName,
        images: images,
        token: token,
      );
      if (response['status'] == 'success') {
        // Get.snackbar('Success', 'Donation added successfully');
        return true;
      } else {
        // Get.snackbar('Error', response.data['message']);
        return false;
      }
    } catch (e) {
      log('Failed to add donation $e');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> editDonation({
    required int id,
    required int exchangePointId,
    required String level,
    required String semester,
    required String description,
    required String donorName,
    required List<File> images,
    required List<int> deletedImages,
  }) async {
    isLoading(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.editDonation(
        id: id,
        exchangePointId: exchangePointId,
        level: level,
        semester: semester,
        description: description,
        donorName: donorName,
        images: images,
        deletedImages: deletedImages,
        token: token,
      );
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog("تم تعديل الحزمة بنجاح");
      } else {
        DialogHelper.showDialog(response.data['message']);
      }
    } catch (e) {
      log('Failed to add donation $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> deleteDonation(int id) async {
    isLoadingDelete(true);
    String token = box.read('token') ?? '';
    try {
      var response = await DonationService.deleteDonation(id, token);
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

  Future<bool> cancelReservationByDonor(int beneficiaryId) async {
    isLoadingDelete(true);
    String token = box.read('token') ?? '';
    try {
      var response =
          await DonationService.cancelReservationByDonor(beneficiaryId, token);
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
