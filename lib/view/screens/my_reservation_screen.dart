import 'dart:developer';

import 'package:book_bridge/view/widgets/custom_donation_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import '../../constants.dart';
import '../../controllers/reservation_controller.dart';
import '../../helper/loading_overlay_helper.dart';
import '../widgets/custom_Button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_categories.dart';
import '../widgets/custom_donation_container_cansel.dart';
import '../widgets/custom_donation_container_not_location.dart';
import '../widgets/custom_donation_container_with_timer_cancel.dart';
import 'subject_screen.dart';

class MyReservationScreen extends StatefulWidget {
  const MyReservationScreen({super.key});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  final ReservationController _reservationController = Get.find<ReservationController>();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> reservations = [];
  bool isLoading = true;
  int currentPage = 1;
  int selectedCategoryIndex = 0;
  String selectedCategoryType = "";

  final List<Map> pageCategories = [
    {'title': 'الحجوزات المنتظر', 'type': 'waitedToReceive','isSelected' : true},
    {'title': 'الحجوزات المنتظره', 'type': 'waitedToCollect','isSelected' : false},
    {'title': 'الحجوزات المسلمة', 'type': 'delivered','isSelected' : false},
    {'title': 'الحجوزات الملغية', 'type': 'failed','isSelected' : false},
  ];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreReservations();
    }
  }

  Future<void> _fetchReservations() async {
    setState(() => isLoading = true);
    _reservationController.waitedReservationsToReceive.clear();
    _reservationController.deliveredReservations.clear();
    _reservationController.waitedReservationsToCollect.clear();
    _reservationController.failedReservations.clear();
    List<dynamic> fetchedReservations =
    await _getReservationsByCategory(currentPage, selectedCategoryIndex);
    setState(() {
      reservations = fetchedReservations; // استخدام مصفوفة جديدة
      isLoading = false;
    });
  }

  Future<void> _loadMoreReservations() async {
    setState(() {
      currentPage++;
      isLoading = true;
    });
    List<dynamic> fetchedReservations =
    await _getReservationsByCategory(currentPage, selectedCategoryIndex);
    setState(() {
      reservations.addAll(
          fetchedReservations); // إضافة للمصفوفة الحالية بدلاً من إعادة الاستخدام
      isLoading = false;
    });
  }

  Future<List<dynamic>> _getReservationsByCategory(int page,
      int categoryIndex) async {
    selectedCategoryType = pageCategories[categoryIndex]['type']!;
    pageCategories[categoryIndex]['isSelected'] = true;
    switch (pageCategories[categoryIndex]['type']) {
      case 'waitedToCollect':
        return await _reservationController.getWaitedReservationsToCollect(page);
      case 'waitedToReceive':
        return await _reservationController.getWaitedReservationsToReceive(page);
      case 'delivered':
        return await _reservationController.getDeliveredReservations(page);
      case 'failed':
        return await _reservationController.getFailedReservations(page);
      default:
        return [];
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      for (var element in pageCategories) {
        element['isSelected'] = false;
      }
      selectedCategoryIndex = index;
      reservations.clear();
      currentPage = 1;
      isLoading = true;
    });
    _fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: "حجوزاتي"),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildCategoryList(),
                isLoading == true ? const Center(child: CircularProgressIndicator())
                    : _buildDonationItems(selectedCategoryType),
              ],
            ),
          ),
        ),
        Obx(() {
          if (_reservationController.isLoadingDelete.value) {
            return const LoadingOverlayHelper();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 50.h,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: pageCategories.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomCategoriesList(
                  onTap: () => {_onCategorySelected(index)},
                  text: pageCategories[index]['title']!,
                  color: pageCategories[index]['isSelected'] ? primary : form,
                  width: 130.w,
                  textColor: pageCategories[index]['isSelected'] ? Colors.white : textColor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationItems(String categoryType) {
    switch (categoryType) {
      case 'waitedToCollect':
        return _buildWaitedToCollectItems();
      case 'waitedToReceive':
        return _buildWaitedToReceiveItems();
      case 'delivered':
        return _buildDeliveredItems();
      case 'failed':
        return _buildFailedItems();
      default:
        return const Center(child: Text('لا توجد حجوزات متاحة.'));
    }
  }

  Widget _buildWaitedToCollectItems() {
    var waitedToCollectReservations = _reservationController.waitedReservationsToCollect;
    return waitedToCollectReservations.isNotEmpty
        ? Column(
      children: [
        ...waitedToCollectReservations.map((reservation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: reservation.id));
          },
          child: CustomDonationContainerWithTimerCancel(
            level: reservation.level,
            semester: reservation.semester,
            residentialQuarter: reservation.residentialQuarter,
            donorName: reservation.donorName,
            pointName: reservation.point,
            date: reservation.createdAt,
            startLeadTimeDateForDonor: reservation.startLeadTimeDateForDonor,
            code: reservation.code,
            onTapCancel: () {
              _cancelReservationInPointByBeneficiary(reservation.bookDonationsId);
            },
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد حجوزات متاحة.'));
  }

  Widget _buildWaitedToReceiveItems() {
    var waitedToReceiveReservations = _reservationController.waitedReservationsToReceive;
    return waitedToReceiveReservations.isNotEmpty
        ? Column(
      children: [
        ...waitedToReceiveReservations.map((reservation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: reservation.id));
          },
          child: CustomDonationContainerCansel(
            level: reservation.level,
            semester: reservation.semester,
            residentialQuarter: reservation.residentialQuarter,
            donorName: reservation.donorName,
            pointName: reservation.point,
            date: reservation.createdAt,
            onTapCancel: () {
              _cancelReservationNotInPointByBeneficiary(reservation.bookDonationsId);
            },

          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد حجوزات متاحة.'));
  }

  Widget _buildDeliveredItems() {
    var deliveredReservations = _reservationController.deliveredReservations;
    return deliveredReservations.isNotEmpty
        ? Column(
      children: [
        ...deliveredReservations.map((reservation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: reservation.id));

          },
          child: CustomDonationContainer(
            level: reservation.level,
            semester: reservation.semester,
            pointName: reservation.point,
            donorName: 'سالم ياسر',
            isPoint: 0,
            date: reservation.createdAt,
            residentialQuarter: reservation.residentialQuarter,
            location: "deliveredReservations.location",
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد حجوزات متاحة.'));
  }

  Widget _buildFailedItems() {
    var rejectedReservations = _reservationController.failedReservations;
    return rejectedReservations.isNotEmpty
        ? Column(
      children: [
        ...rejectedReservations.map((reservation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: reservation.id));

          },
          child: CustomDonationContainerNotLocation(
            level: reservation.level,
            semester: reservation.semester,
            residentialQuarter: reservation.residentialQuarter,
            donorName: reservation.donorName,
            pointName: reservation.point,
            date: reservation.createdAt,
            isPoint: 0,
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد حجوزات متاحة.'));
  }

  void _showDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Dialogs.bottomMaterialDialog(
        msg: message,
        context: context,
      );
    });
  }

  void _cancelReservationNotInPointByBeneficiary(int beneficiaryId) async {
    setState(() {
      Dialogs.materialDialog(
        msg: 'هل تريد الغاء الحجز؟',
        title: 'الغاء الحجز',
        context: context,
        actions: [
          CustomButton(
              color: form,
              textColor: primary,
              text: "لا",
              width: 150.w,
              height: 40.h,
              onTap: () {
                Navigator.of(context).pop(false);
              }),
          CustomButton(
              color: primary,
              textColor: form,
              text: "نعم",
              width: 150.w,
              height: 40.h,
              onTap: () async {
                try {
                  bool success = await _reservationController.cancelReservationNotInPointByBeneficiary(beneficiaryId);
                  if (success) {
                    _showDialog('تمت الغاء الحجز بنجاح');
                    setState(() {
                      _fetchReservations();
                    });
                    // Navigator.pop(context);
                  } else {
                    _showDialog('حدث خطأ أثناء الغاء الحجز');
                  }
                } catch (e) {
                  log('Error parsing values: $e');
                  _showDialog('حدث خطأ أثناء معالجة البيانات');
                }
                setState(() {
                  Navigator.pop(context);
                });
              }),
        ],
      );
    });
  }

  void _cancelReservationInPointByBeneficiary(int beneficiaryId) async {
    setState(() {
      Dialogs.materialDialog(
        msg: 'هل تريد الغاء الحجز؟',
        title: 'الغاء الحجز',
        context: context,
        actions: [
          CustomButton(
              color: form,
              textColor: primary,
              text: "لا",
              width: 150.w,
              height: 40.h,
              onTap: () {
                Navigator.of(context).pop(false);
              }),
          CustomButton(
              color: primary,
              textColor: form,
              text: "نعم",
              width: 150.w,
              height: 40.h,
              onTap: () async {
                try {
                  bool success = await _reservationController.cancelReservationInPointByBeneficiary(beneficiaryId);
                  if (success) {
                    _showDialog('تمت الغاء الحجز بنجاح');
                    setState(() {
                      _fetchReservations();
                    });
                    // Navigator.pop(context);
                  } else {
                    _showDialog('حدث خطأ أثناء الغاء الحجز');
                  }
                } catch (e) {
                  log('Error parsing values: $e');
                  _showDialog('حدث خطأ أثناء معالجة البيانات');
                }
                setState(() {
                  Navigator.pop(context);
                });
              }),
        ],
      );
    });
  }



}
