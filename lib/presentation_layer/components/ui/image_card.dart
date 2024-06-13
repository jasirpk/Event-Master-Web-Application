import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  ImageCard(this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/all_projects_right_image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
