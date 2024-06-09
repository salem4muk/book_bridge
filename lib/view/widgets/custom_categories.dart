// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';

class CustomCategoriesList extends StatelessWidget {
  CustomCategoriesList(
      {required this.text,
        required this.color,
        required this.textColor,
        required this.width,
        required this.onTap,
        super.key});

  final String? text;
  final Color color;
  final Color textColor;
  final double? width;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: 45,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                text!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

