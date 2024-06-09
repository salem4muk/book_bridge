import 'package:book_bridge/controllers/donation_controller.dart';
import 'package:book_bridge/helper/function_helper.dart';
import 'package:book_bridge/view/widgets/custom_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants.dart';
import '../../helper/loading_overlay_helper.dart';
import '../../models/donation_model.dart';
import '../widgets/custom_Button.dart';
import 'notification_screen.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key, required this.id});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
  final int id;
}

class _SubjectScreenState extends State<SubjectScreen> {
  final DonationController _donationController = Get.find<DonationController>();
  dynamic? donation;
  bool isLoading = true;
  int activeIndex = 0;

  Future<void> _fetchDonations() async {
    setState(() {
      isLoading = true;
    });
    donation = await _donationController.getDonation(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchDonations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: "تفاصيل التبرع"),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : donation == null
                  ? const Center(child: Text('لم يتم العثور على التبرع'))
                  : Directionality(
                      textDirection: TextDirection.rtl,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // image slider
                            if (donation!.images.isNotEmpty)
                              CarouselSlider.builder(
                                itemCount: donation!.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  final urlImage =
                                      donation!.images[index].source;
                                  return buildImage(urlImage, index);
                                },
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height: 200.h,
                                  viewportFraction: 0.8,
                                  aspectRatio: 16 / 9,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            // Space
                            SizedBox(
                              height: 12.h,
                            ),
                            buildIndicator(),

                            // subject name
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10).h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("حزمة الصف ${donation!.level}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(color: textColor)),
                                  const Text(
                                    " / ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    donation!.semester,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: textColor),
                                  ),
                                ],
                              ),
                            ),
                            // donor name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  IconlyBroken.profile,
                                  color: mainText,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 5,
                                  ).w,
                                  child: Text(
                                      donation!.donorName ?? 'Unknown Donor',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(color: primary)),
                                ),
                              ],
                            ),
                            // description
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 10).h,
                              child: SizedBox(
                                width: 320.w,
                                child: Text(
                                    donation!.description ?? 'لا يوجد وصف',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                            ),
                            // time and location container
                            Container(
                                height: 180.h,
                                width: 320.w,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13).r,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.5,
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          IconlyBroken.location,
                                          color: mainText,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SizedBox(
                                          width: 250.w,
                                          child: Text(
                                            "${donation!.residentialQuarter} / ${donation!.pointName}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          IconlyBroken.calendar,
                                          color: mainText,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          donation!.date,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: textColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          IconlyBroken.bookmark,
                                          color: mainText,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SizedBox(
                                          width: 240.w,
                                          child: Text(
                                            donation!.isInPoint == 1
                                                ? "الحزمة موجودة في النقطة بلفعل"
                                                : "الحزمة غير موجودة في النقطة",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FunctionHelper().openUrl(Uri.parse(donation!.location));
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: primary),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.globe,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text("عرض موقع الحزمة ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            // space
                            SizedBox(
                              height: 30.h,
                            ),
                            // Button For Add Donation
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: CustomButton(
                                  color: primary,
                                  textColor: form,
                                  text: "طلب الحزمة",
                                  width: 320.w,
                                  height: 50.h,
                                  onTap: () {
                                    setState(() {
                                      _donationController
                                          .bookingDonations(widget.id);
                                    });
                                  }),
                            )
                          ],
                        ),
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

  // This is the container widget of Indicator - dots (..) -
  Widget buildIndicator() => AnimatedSmoothIndicator(
        effect: ExpandingDotsEffect(
            dotWidth: 7.w,
            dotHeight: 5.h,
            activeDotColor: primary,
            dotColor: outline),
        activeIndex: activeIndex,
        count: donation!.images.length,
      );
}

// // This is the container widget of slider image
Widget buildImage(String urlImage, int index) {
  return InstaImageViewer(
    child: Container(
        width: 120.w,
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(15).r,
          image: DecorationImage(
              image: NetworkImage(baseUrlPathImage + urlImage),
              // Replace with your image path
              fit: BoxFit.fill),
        )),
  );
}
