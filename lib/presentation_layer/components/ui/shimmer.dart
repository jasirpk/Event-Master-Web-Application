import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ShimmerLoadingEffect({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: MasonryGridView.count(
        crossAxisCount: 3,
        itemCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemBuilder: (context, index) {
          return Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerLoadingCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ShimmerLoadingCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey,
      child: Container(
        height: screenHeight * 0.3,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
