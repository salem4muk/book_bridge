// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class CustomTextFieldAddDonation extends StatelessWidget {
  CustomTextFieldAddDonation(
      {super.key,
        this.maxLine = 1,
        this.icon,
        this.enabled = true,
        required this.hint,
        this.controller,
        this.maxLength,
        this.validator,
        this.radius = 10});

  int maxLine;
  IconData? icon;
  String hint;
  double radius;
  bool enabled;
  int? maxLength;
  TextEditingController? controller;
  String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // style: TextStyle(color: secondaryText),
        maxLength: maxLength,
        controller: controller,
        validator: validator,
        maxLines: maxLine,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).r,
            borderSide: const BorderSide(color: outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).r,
            borderSide: const BorderSide(color: outline),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).r,
            borderSide: const BorderSide(color: outline),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).r,
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius).r,
            borderSide: const BorderSide(color: Colors.red),
          ),
          prefixIcon: icon == null ? null : Icon(icon),
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: secondaryText),
          enabled: enabled,
          filled: true,
          fillColor: Colors.white,
        ));
  }
}
