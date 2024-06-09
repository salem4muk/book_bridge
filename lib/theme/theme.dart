import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';

class AppTheme {
  static final appTheme = ThemeData(
    fontFamily: "Cairo",
    primaryColor: primary,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: mainText,
        fontFamily: 'Cairo',
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
