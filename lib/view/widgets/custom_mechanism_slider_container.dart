// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

// format of introduction screen

class CustomMechanismSliderContainer extends StatelessWidget {
  const CustomMechanismSliderContainer({
    super.key,
    required this.image,
    required this.descrption,
  });

  final String image, descrption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Spacer(),
        Image.asset(
          image,
          height: 300.h,
        ),
        // const Spacer(),
         SizedBox(
          height: 30.h,
        ),
        SizedBox(
          width: 340.w,
          child: Text(descrption,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(color: textColor,fontWeight: FontWeight.normal)),
        ),
        // const Spacer(),
      ],
    );
  }
}
