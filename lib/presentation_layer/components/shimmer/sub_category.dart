import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSubCategory extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerSubCategory(
      {Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
}
