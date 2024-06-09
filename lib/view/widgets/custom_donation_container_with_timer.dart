// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';
import '../../constants.dart';
import 'custom_count_dawn.dart';

class CustomDonationContainerWithTimer extends StatefulWidget {
  const CustomDonationContainerWithTimer({
    super.key,
    required this.level,
    required this.semester,
    required this.residentialQuarter,
    required this.donorName,
    required this.pointName,
    required this.date,
    required this.startLeadTimeDateForDonor,
    required this.isPoint,
  });

  final String level,
      semester,
      donorName,
      date,
      pointName,
      residentialQuarter,
      startLeadTimeDateForDonor;
  final int isPoint;

  @override
  State<CustomDonationContainerWithTimer> createState() => _CustomDonationContainerWithTimerState();
}

class _CustomDonationContainerWithTimerState extends State<CustomDonationContainerWithTimer> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 140.h,
        width: 700.w,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: lineColor,
              // specify your desired color
              width: 1.0.w, // specify the width of the border
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(widget.level,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: textColor)),
                    const Text(" /"),
                    Text(widget.semester,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: textColor)),
                  ],
                ),
                Row(children: [
                  const Icon(
                    IconlyBroken.location,
                    color: mainText,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(widget.residentialQuarter,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: textColor)),
                  const Text(" /"),
                  Text(widget.pointName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: textColor)),
                ]),
                // Row(
                //   children: [
                //     const Icon(
                //       IconlyBroken.profile,
                //       color: mainText,
                //     ),
                //     SizedBox(
                //       width: 3.w,
                //     ),
                //     Text(widget.donorName,
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodyMedium!
                //             .copyWith(color: secondaryText)),
                //   ],
                // ),
                Row(
                  children: [
                    const Icon(
                      IconlyBroken.calendar,
                      color: mainText,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(widget.date,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: primary)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // InkWell(
                //   onTap: () {
                //     // MapUtils.openMap();
                //     //await openUrlWithConnectivityCheck(location);
                //     // _launchUrl(Uri.parse(location));
                //     // _openGoogleMaps("https://maps.app.goo.gl/izL1kbwRXFkRaSqQ9");
                //   },
                //   child: Container(
                //     width: 100,
                //     height: 40,
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: primary),
                //     child: Row(
                //       children: [
                //         const Icon(
                //           FontAwesomeIcons.globe,
                //           color: Colors.white,
                //         ),
                //         SizedBox(
                //           width: 5.w,
                //         ),
                //         Text("الموقع",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .titleMedium!
                //                 .copyWith(color: Colors.white)),
                //       ],
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: widget.isPoint == 1 ? true : false,
                  child: Row(
                    children: [
                      const Icon(
                        IconlyBold.bookmark,
                        color: primary,
                        size: 20,
                      ),
                      SizedBox(width: 5.w,),
                      Text("في النقطة",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: secondaryText)),
                    ],
                  ),
                ),
                CustomCountDown(deadline: DateTime.now().add(const Duration(days: 3)))

              ],
            ),
          ],
        ),
      ),
    );
  }
}