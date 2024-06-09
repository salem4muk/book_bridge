// ignore_for_file: deprecated_member_use

import 'package:book_bridge/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';
import '../widgets/custom_DotIndicator.dart';
import '../widgets/custom_mechanism_slider_container.dart';
import 'home_screen.dart';


class DonationMechanismScreen extends StatefulWidget {
  const DonationMechanismScreen({super.key});

  @override
  State<DonationMechanismScreen> createState() =>
      _DonationMechanismScreenState();
}

class _DonationMechanismScreenState extends State<DonationMechanismScreen> {
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
      appBar: const CustomAppBar(title: "الية التبرع"),
      body: Padding(
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
                  itemBuilder: (context, index) => CustomMechanismSliderContainer(
                    image: demoData[index].image,
                    descrption: demoData[index].description,
                  ),
                ),
              ),
              // Dots
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
                  // Bottom
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
    image: "assets/Img/intro-1.png",
    description: "قم بإضافة تبرع جديد",
  ),
  Onboard(
    image: "assets/Img/intro-2.png",
    description:
    " أدخل البيانات الخاصة بالتبرع ، السنة الدراسية ، الفصل ، والنقطة التي ترغب بوضعا الكتب فيها ، وبشكل اختياري قم بوصف حالة الكتب وأضف بعض الصور",
  ),
  Onboard(
    image: "assets/Img/intro-3.png",
    description:
    "انتظر حتى يأتيك إشعار بأن طالبا يريد الاستفادة من الكتب الدراسية التي تبرعت بها",
  ),
  Onboard(
    image: "assets/Img/intro-4.png",
    description:
    "قم بإيصال الكتب إلى النقطة في المهلة المحددة",
  ),
  Onboard(
    image: "assets/Img/intro-5.png",
    description:
    " بإمكانك إيصال التبرعات الأخرى التي لم تحجز بعد ، كحد أقصى حزمتين إضافتين",
  ),
  Onboard(
    image: "assets/Img/intro-6.png",

    description:
    "تأكد من وصول إشعار لك باستلام تبرعك ، في حال لم يصلك تواصل معنا",
  )
];
