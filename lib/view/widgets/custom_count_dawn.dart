import 'dart:async';

import 'package:flutter/material.dart';

class CustomCountDown extends StatefulWidget {
  const CustomCountDown(
      {super.key, required this.deadline, this.textStyle, this.labelTextStyle});

  final DateTime deadline;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;

  @override
  State<CustomCountDown> createState() => _CustomCountDownState();
}

class _CustomCountDownState extends State<CustomCountDown> {
  late Timer timer;
  Duration duration = const Duration();

  @override
  void initState() {
    calculateTimeLeft(widget.deadline);
    timer = Timer.periodic(
        const Duration(seconds: 1), (_) => calculateTimeLeft(widget.deadline));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle =
        widget.textStyle ?? Theme.of(context).textTheme.subtitle2!;
    // var labelTextStyle =
    //     widget.labelTextStyle ?? Theme.of(context).textTheme.subtitle2!;
    final days = DefaultTextStyle(
        style: textStyle,
        child: Text(duration.inDays.toString().padLeft(2, '0')));
    final hours = DefaultTextStyle(
        style: textStyle,
        child: Text(duration.inHours.remainder(24).toString().padLeft(2, '0')));
    final minutes = DefaultTextStyle(
        style: textStyle,
        child:
        Text(duration.inMinutes.remainder(60).toString().padLeft(2, '0')));
    final second = DefaultTextStyle(
        style: textStyle,
        child:
        Text(duration.inSeconds.remainder(60).toString().padLeft(2, '0')));

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bound) => const LinearGradient(
                          colors: [Color(0xff192256), Color(0xff3e5d9e)])
                          .createShader(Rect.fromLTWH(0, 0, bound.width, bound.height)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: days,
                      ),
                    ),
                    // DefaultTextStyle(
                    //     style: labelTextStyle, child: const Text("الايام")),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bound) => const LinearGradient(
                          colors: [Color(0xff192256), Color(0xff3e5d9e)])
                          .createShader(Rect.fromLTWH(0, 0, bound.width, bound.height)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: hours,
                      ),
                    ),
                    // DefaultTextStyle(
                    //     style: labelTextStyle, child: const Text("الساعات",)),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bound) => const LinearGradient(
                          colors: [Color(0xff192256), Color(0xff3e5d9e)])
                          .createShader(Rect.fromLTWH(0, 0, bound.width, bound.height)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:5),
                        child: minutes,
                      ),
                    ),
                    // DefaultTextStyle(
                    //     style: labelTextStyle, child: const Text("الدقائق")),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bound) => const LinearGradient(
                          colors: [Color(0xff192256), Color(0xff3e5d9e)])
                          .createShader(Rect.fromLTWH(0, 0, bound.width, bound.height)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: second,
                      ),
                    ),
                    // DefaultTextStyle(
                    //     style: labelTextStyle, child: const Text("الثواني")),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void calculateTimeLeft(DateTime deadline) {
    final seconds = deadline.difference(DateTime.now()).inSeconds;
    setState(() {
      duration = Duration(seconds: seconds);
    });
  }
}
