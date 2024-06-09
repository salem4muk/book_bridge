import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hint,
    required this.suffixIcon,
    this.prefixIcon,
    this.onTapPrefixIcon,
    this.onChanged,
    this.obscureText = false,
    this.validater,
    this.filled = false,
    this.enabled = true,
    this.controller,
    this.initialValue,
    this.onEditingComplete,
  });

  String hint;
  IconData suffixIcon;
  IconData? prefixIcon;
  VoidCallback? onTapPrefixIcon;
  bool obscureText;
  bool filled;
  bool enabled;
  String? initialValue;
  TextEditingController? controller;
  Function()? onEditingComplete;

  String? Function(String?)? validater;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10).h,
      child: TextFormField(
        readOnly: !enabled,
        controller: controller,
        initialValue: initialValue,
        validator: validater,
        obscureText: obscureText,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        // keyboardType: TextInputType.phone,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40).r,
            borderSide: const BorderSide(color: outline),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40).r,
            borderSide: const BorderSide(color: textColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40).r,
            borderSide: const BorderSide(color: primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40).r,
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40).r,
            borderSide: const BorderSide(color: Colors.red),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: "Cairo",
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),

          suffixIcon: IconButton(
            icon: Icon(
              prefixIcon,
              color: mainText,
            ),
            onPressed: onTapPrefixIcon,
          ),
          prefixIcon: Icon(
            suffixIcon,
            color: mainText,
          ),
          filled: filled,
          enabled: enabled,
        ),
      ),
    );
  }
}
