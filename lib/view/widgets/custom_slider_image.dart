import 'package:flutter/material.dart';

class CustomSliderImage extends StatelessWidget {
  const CustomSliderImage(
      {super.key,
        this.border,
        this.padding,
        this.width,
        this.height ,
        this.applyImageRadius = false,
        required this.imageUrl,
        this.fit = BoxFit.contain,
        this.backgroundColor = Colors.white,
        this.borderRadius = 15});

  final double? width;
  final double? height;
  final bool applyImageRadius;
  final double borderRadius;
  final String imageUrl;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;

  // final bool isNetworkImage;
  // final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: applyImageRadius
            ? BorderRadius.circular(borderRadius)
            : BorderRadius.zero,
        image: DecorationImage(
          image: AssetImage(imageUrl),
          // Replace with your image path
          fit: fit ?? BoxFit.cover,// Adjust fit as needed (cover, fill, etc.)
        ),
      ),
    );
  }
}
