import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

class LoadingOverlayHelper  extends StatelessWidget {
  const LoadingOverlayHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: primary,
        size: 30.sp,
      ),
    );
  }
}
