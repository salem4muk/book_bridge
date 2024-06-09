import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../constants.dart';

class CustomFollowNotification extends StatefulWidget {
  const CustomFollowNotification({super.key, required this.title, this.description, required this.createdAt});
  final String title;
  final String? description;
  final String createdAt;

  @override
  State<CustomFollowNotification> createState() =>
      _CustomFollowNotificationState();
}

class _CustomFollowNotificationState extends State<CustomFollowNotification> {
  bool read = false;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: mainText),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              widget.description ?? widget.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: secondaryText),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                const Icon(
                  IconlyBroken.calendar,
                  color: mainText,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(widget.createdAt,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: primary)),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 15.w,
        ),
        // CircleAvatar(
        //   radius: 27.r,
        //   backgroundImage: const AssetImage("assets/Img/book_2.jpg"),
        // ),
      ],
    );
  }
}
