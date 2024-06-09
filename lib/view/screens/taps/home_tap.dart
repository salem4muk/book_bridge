import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants.dart';
import '../../../models/donation_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_donation_container.dart';
import '../search_screen.dart';
import '../subject_screen.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({Key? key}) : super(key: key);

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> with AutomaticKeepAliveClientMixin {
  int activeIndex = 0;
  final List<String> urlImages = [
    "assets/Img/slider-1.png",
    "assets/Img/slider-2.png",
    "assets/Img/slider-3.png",
  ];

  final DonationController _donationController = Get.find<DonationController>();
  List<dynamic> donations = [];
  bool isLoading = true;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchDonations();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreDonations();
      }
    });
  }

  Future<void> _fetchDonations() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> fetchedDonations = await _donationController.getLastDonations(currentPage);
    setState(() {
      donations.addAll(fetchedDonations);
      isLoading = false;
    });
  }

  void _loadMoreDonations() {
    if (!isLoading) {
      setState(() {
        currentPage++;
      });
      _fetchDonations();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                _buildSlider(),
                SizedBox(height: 12.h),
                _buildSliderDots(),
                SizedBox(height: 25.h),
                _buildSearchButton(),
                _buildDonationItems(),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return CarouselSlider.builder(
      itemCount: urlImages.length,
      itemBuilder: (context, index, realIndex) {
        final urlImage = urlImages[index];
        return _buildImage(urlImage, index);
      },
      options: CarouselOptions(
        autoPlay: true,
        height: 130.h,
        onPageChanged: (index, reason) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSliderDots() {
    return AnimatedSmoothIndicator(
      effect: const ExpandingDotsEffect(
        dotWidth: 10.0,
        dotHeight: 5.0,
        activeDotColor: primary,
        dotColor: outline,
      ),
      activeIndex: activeIndex,
      count: urlImages.length,
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: CustomButton(
        color: primary,
        textColor: Colors.white,
        text: "بحث",
        width: 200.w,
        height: 50.h,
        onTap: () {
          Get.to(() => const SearchScreen());

        },
      ),
    );
  }

  Widget _buildDonationItems() {
    if (donations.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (donations.isEmpty) {
      return const Center(child: Text('لا توجد تبرعات متاحة.'));
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            ...donations.map((donation) {
              return InkWell(
                onTap: () {
                  Get.to(() => SubjectScreen(id: donation.id));
                },
                child: CustomDonationContainer(
                  level: donation.level,
                  semester: donation.semester,
                  pointName: donation.pointName,
                  donorName: donation.donorName ?? 'سالم ياسر',
                  isPoint: donation.isInPoint ?? 0,
                  date: donation.date,
                  residentialQuarter: donation.residentialQuarter,
                  location: donation.location,
                ),
              );
            }).toList(),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          image: AssetImage(urlImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
