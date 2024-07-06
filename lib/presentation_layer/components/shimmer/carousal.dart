import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCarouselItem extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ShimmerCarouselItem({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF37474F),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.teal),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3))],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 8, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.03,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.02,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    // Handle popup menu actions if needed
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      ),
                      PopupMenuItem(
                        child: Text('View Detail'),
                        value: 'View Detail',
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
