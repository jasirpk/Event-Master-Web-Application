import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEntrepreneurs extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ShimmerEntrepreneurs({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white,
      child: Container(
        height: screenHeight * 0.3,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }
}
