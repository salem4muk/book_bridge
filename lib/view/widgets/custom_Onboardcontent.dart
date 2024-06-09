// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

// format of introduction screen

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.titel,
    required this.descrption,
  });

  final String image, titel, descrption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Spacer(),
        Image.asset(
          image,
          height: 350,
        ),
        // const Spacer(),
        Text(
          titel,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(descrption,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge),
        // const Spacer(),
      ],
    );
  }
}
