import 'dart:developer';

import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:book_bridge/view/screens/donation/edit.dart';
import 'package:book_bridge/view/widgets/custom_donation_container.dart';
import 'package:book_bridge/view/widgets/custom_donation_container_not_location.dart';
import 'package:book_bridge/view/widgets/custom_donation_container_with_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import '../../constants.dart';
import '../../helper/loading_overlay_helper.dart';
import '../widgets/custom_Button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_categories.dart';
import '../widgets/custom_donation_container_for_doner.dart';
import '../widgets/custom_donation_container_with_timer_cancel.dart';
import 'subject_screen.dart';

class MyDonationScreen extends StatefulWidget {
  const MyDonationScreen({super.key});

  @override
  State<MyDonationScreen> createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  final DonationController _donationController = Get.find<DonationController>();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> donations = [];
  bool isLoading = true;
  int currentPage = 1;
  int selectedCategoryIndex = 0;
  String selectedCategoryType = "";

  final List<Map> pageCategories = [
    {'title': 'التبرعات المنتظر حجزها', 'type': 'undelivered','isSelected' : true},
    {'title': 'التبرعات المنتظر تسليمها', 'type': 'waited','isSelected' : false},
    {'title': 'التبرعات المسلمة', 'type': 'delivered','isSelected' : false},
    {'title': 'التبرعات المرفوضة', 'type': 'rejected','isSelected' : false},
  ];

  @override
  void initState() {
    super.initState();
    _fetchDonations();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreDonations();
    }
  }

  Future<void> _fetchDonations() async {
    setState(() => isLoading = true);
    _donationController.undeliveredDonations.clear();
    _donationController.waitedDonations.clear();
    _donationController.deliveredDonations.clear();
    _donationController.rejectedDonations.clear();
    List<dynamic> fetchedDonations =
    await _getDonationsByCategory(currentPage, selectedCategoryIndex);
    setState(() {
      donations = fetchedDonations; // استخدام مصفوفة جديدة
      isLoading = false;
    });
  }

  Future<void> _loadMoreDonations() async {
    setState(() {
      currentPage++;
      isLoading = true;
    });
    List<dynamic> fetchedDonations =
    await _getDonationsByCategory(currentPage, selectedCategoryIndex);
    setState(() {
      donations.addAll(
          fetchedDonations); // إضافة للمصفوفة الحالية بدلاً من إعادة الاستخدام
      isLoading = false;
    });
  }

  Future<List<dynamic>> _getDonationsByCategory(int page,
      int categoryIndex) async {
    selectedCategoryType = pageCategories[categoryIndex]['type']!;
    pageCategories[categoryIndex]['isSelected'] = true;
    switch (pageCategories[categoryIndex]['type']) {
      case 'undelivered':
        return await _donationController.getUndeliveredDonations(page);
      case 'waited':
        return await _donationController.getWaitedDonationsForUser(page);
      case 'delivered':
        return await _donationController.getDeliveredDonationsForUser(page);
      case 'rejected':
        return await _donationController.getRejectedDonationsForUser(page);
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
      donations.clear();
      currentPage = 1;
      isLoading = true;
    });
    _fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: "تبرعاتي"),
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
          if (_donationController.isLoadingDelete.value) {
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
      case 'undelivered':
        return _buildUndeliveredItems();
      case 'waited':
        return _buildWaitedItems();
      case 'delivered':
        return _buildDeliveredItems();
      case 'rejected':
        return _buildRejectedItems();
      default:
        return const Center(child: Text('لا توجد تبرعات متاحة.'));
    }
  }

  Widget _buildUndeliveredItems() {
    var undeliveredDonations = _donationController.undeliveredDonations;
    return undeliveredDonations.isNotEmpty
        ? Column(
      children: [
        ...undeliveredDonations.map((donation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: donation.id));

          },
          child: CustomDonationContainerForDonor(
            id: donation.id,
            level: donation.level,
            semester: donation.semester,
            residentialQuarter: donation.residentialQuarter,
            donorName: donation.donorName,
            pointName: donation.point,
            date: donation.createdAt,
            onTapEdit: () {
              Get.to(() => EditDonationScreen(id: donation.id,),);
            },
            onTapDelete: () {
              _deleteDonation(donation.id);
            },
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد تبرعات متاحة.'));
  }

  Widget _buildWaitedItems() {
    var waitedDonations = _donationController.waitedDonations;
    return waitedDonations.isNotEmpty
        ? Column(
      children: [
        ...waitedDonations.map((donation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: donation.id));
          },
          child: CustomDonationContainerWithTimerCancel(
            level: donation.level,
            semester: donation.semester,
            residentialQuarter: donation.residentialQuarter,
            donorName: donation.donorName,
            pointName: donation.point,
            date: donation.createdAt,
            code:0,
            startLeadTimeDateForDonor: donation.startLeadTimeDateForDonor,
            onTapCancel: (){
              _cancelReservationByDonor(donation.beneficiaryId);
            }
            ,
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد تبرعات متاحة.'));
  }

  Widget _buildDeliveredItems() {
    var deliveredDonations = _donationController.deliveredDonations;
    return deliveredDonations.isNotEmpty
        ? Column(
      children: [
        ...deliveredDonations.map((donation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: donation.id));
          },
          child: CustomDonationContainerNotLocation(
            level: donation.level,
            semester: donation.semester,
            residentialQuarter: donation.residentialQuarter,
            donorName: donation.donorName ?? "donor Name",
            pointName: donation.point,
            date: donation.createdAt,
            isPoint: 0,
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد تبرعات متاحة.'));
  }

  Widget _buildRejectedItems() {
    var rejectedDonations = _donationController.rejectedDonations;
    return rejectedDonations.isNotEmpty
        ? Column(
      children: [
        ...rejectedDonations.map((donation) => InkWell(
          onTap: (){
            Get.to(() => SubjectScreen(id: donation.id));
          },
          child: CustomDonationContainerNotLocation(
            level: donation.level,
            semester: donation.semester,
            residentialQuarter: donation.residentialQuarter,
            donorName: donation.donorName ?? "donorName",
            pointName: donation.point,
            date: donation.createdAt,
            isPoint: 0,
          ),
        )).toList(),
      ],
    )
        : const Center(child: Text('لا توجد تبرعات متاحة.'));
  }

  void _showDialog(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Dialogs.bottomMaterialDialog(
        msg: message,
        context: context,
      );
    });
  }

  void _deleteDonation(int id) async {
    setState(() {
      Dialogs.materialDialog(
        msg: 'هل تريد حذف التبرع؟',
        title: 'حذف التبرع',
        context: context,
        actions: [
          CustomButton(
              color: form,
              textColor: primary,
              text: "إلغاء",
              width: 150.w,
              height: 40.h,
              onTap: () {
                Navigator.of(context).pop(false);
              }),
          CustomButton(
              color: primary,
              textColor: form,
              text: "حذف",
              width: 150.w,
              height: 40.h,
              onTap: () async {
                try {
                  bool success = await _donationController.deleteDonation(id);
                  if (success) {
                    _showDialog('تمت حذف الحزمة بنجاح');
                    setState(() {
                    });
                    // Navigator.pop(context);
                  } else {
                    _showDialog('حدث خطأ أثناء حذف الحزمة');
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

  void _cancelReservationByDonor(int beneficiaryId) async {
    setState(() {
      Dialogs.materialDialog(
        msg: 'هل تريد الغاء التبرع؟',
        title: 'الغاء التبرع',
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
                  bool success = await _donationController.cancelReservationByDonor(beneficiaryId);
                  if (success) {
                    _showDialog('تمت الغاء الحجز بنجاح');
                    setState(() {
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
