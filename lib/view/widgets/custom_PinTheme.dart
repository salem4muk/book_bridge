import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../constants.dart';

class customPinTheme extends StatelessWidget {
  customPinTheme({super.key});
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: outline,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Pinput(
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: primary),
            )
          // obscureText: true,

        ));
  }
}
