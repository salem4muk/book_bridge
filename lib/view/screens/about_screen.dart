// ignore_for_file: deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';
import '../widgets/custom_app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "عن التطبيق"),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20).h,
                child: Column(
                  children: [
                    SizedBox(
                      child: Container(
                        height: 100.h,
                        width: 700.w,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(
                              image: const AssetImage("assets/Img/logo.png"),
                              width: 50.w,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                "منصة اللكترونية لتبادل الكتب التعليمية",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10).w,
                      height: 50.h,
                      width: 700.w,
                      color: form,
                      child: Text(
                        "معلومات",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(IconlyBroken.info_circle,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "من نحن",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(IconlyBroken.info_circle,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10).h,
                                    child: Text(
                                      "الشروط والأحكام",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      height: 50.h,
                      width: 700.h,
                      color: form,
                      child: Text(
                        "اتصل بنا على",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(IconlyBroken.call, color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "الهاتف",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.whatsapp,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "واتساب",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(IconlyBroken.message,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "الهاتف",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10).w,
                      height: 50.h,
                      width: 700.w,
                      color: form,
                      child: Text(
                        "تابعنا على",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.facebook,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "فيسبوك",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.instagram,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "انستقرام",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.twitter,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "تويتر",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      height: 50,
                      width: double.infinity,
                      color: form,
                      child: Text(
                        "تابعنا على",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: primary),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.share,
                                      color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "مشاركة التطبيق",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: lineColor,
                            // specify your desired color
                            width: 1.0.w, // specify the width of the border
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ChatTap()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12).w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(IconlyBroken.star, color: primary),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "تقييم التطبيق",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                IconlyBroken.arrow_left_2,
                                color: iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15).h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50).r,
                              image: const DecorationImage(
                                  image: AssetImage("assets/Img/logo_team.jpg"),
                                  // Replace with your image path
                                  fit: BoxFit
                                      .fill // Adjust fit as needed (cover, fill, etc.)
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7.w,
                          ),
                          Text(
                            "تصميم وتطوير",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: textColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
