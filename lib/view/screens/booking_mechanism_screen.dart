// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';
import '../widgets/custom_DotIndicator.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_mechanism_slider_container.dart';
import 'home_screen.dart';

class BookingMechanismScreen extends StatefulWidget {
  const BookingMechanismScreen({super.key});

  @override
  State<BookingMechanismScreen> createState() => _BookingMechanismScreenState();
}

class _BookingMechanismScreenState extends State<BookingMechanismScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "آلية الحجز",
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: demoData.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) =>
                        CustomMechanismSliderContainer(
                          image: demoData[index].image,
                          descrption: demoData[index].description,
                        ),
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(
                        demoData.length,
                            (index) => Padding(
                          padding: const EdgeInsets.only(right: 4).w,
                          child: DotIndicator(
                            isActive: index == _pageIndex,
                          ),
                        )),
                    const Spacer(),
                    SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_pageIndex < demoData.length - 1) {
                                // Advance to the next page
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              } else {
                                // Reset to the first page
                                _pageController.jumpToPage(0);
                              }
                              _pageIndex = (_pageIndex + 1) % demoData.length;
                            });

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(IconlyBroken.arrow_right),
                        )),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class Onboard {
  final String image, description;

  Onboard({
    required this.image,
    required this.description,
  });
}

final List<Onboard> demoData = [
  Onboard(
    image: "assets/Img/booking_1.png",
    description: "يقوم الشخص الراغب في الأستفادة من حزم الكتب بحجز أحداها",
  ),
  Onboard(
    image: "assets/Img/intro-5.png",
    description:
    "إذا كانت حزمة الكتب في النقطة يمهل المستفيد مدة يوم واحد لاستلامه",
  ),
  Onboard(
    image: "assets/Img/booking_3.png",
    description:
    "يجب على المستفيد إعطاء عامل النقطة كود التحقق عند استلام حزمة الكتب",
  ),
  Onboard(
    image: "assets/Img/booking_4.png",
    description:
    "في حال أن حزمة الكتب المحجوزة ليست في النقطة ينتظر إلى أن يتم تسليمها من قبل المتبرع",
  ),
  Onboard(
    image: "assets/Img/booking_5.png",
    description: "في حال لم يسلم المتبرع حزمة الكتب يلغى الحجز",
  ),
  Onboard(
    image: "assets/Img/booking_6.png",
    description: "للمستفيد أحقية رفض حزمة الكتب التي لا تلبي رغباته في جودتها ",
  ),
  Onboard(
    image: "assets/Img/booking_7.png",
    description:
    "يجب على المستفيد إعطاء عامل النقطة مبلغ ٣٠٠ ريال نظير أتعابه ومساهمته في عملية إتمام التبرع من الاحتفاظ بحزم الكتب ودعم سير العملية",
  ),
];
