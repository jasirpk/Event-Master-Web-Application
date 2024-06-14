import 'dart:ui';

import 'package:flutter/material.dart';

class SilverStackAppBar extends StatelessWidget {
  const SilverStackAppBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Image.asset(
                  'assets/images/we_img.webp',
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Screenshot 2024-05-22 205021.png'),
                                fit: BoxFit.cover),
                            border: Border.all(color: Colors.teal, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.4,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    child: CircleAvatar(
                                      maxRadius: screenHeight * 0.06,
                                      backgroundImage: AssetImage(
                                        'assets/images/google_ath_img.jpg',
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Entrepreneur',
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.06,
                                          fontFamily: 'JacquesFracois'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/Screenshot 2024-05-22 205021.png',
                                    ),
                                    fit: BoxFit.cover),
                                border:
                                    Border.all(color: Colors.teal, width: 3),
                                borderRadius: BorderRadius.circular(10)),
                            width: screenWidth * 0.2,
                            height: screenHeight * 0.4,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: CircleAvatar(
                                        maxRadius: screenHeight * 0.06,
                                        backgroundImage: AssetImage(
                                          'assets/images/Circle-icons-profile.svg.png',
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'User',
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.06,
                                            fontFamily: 'JacquesFracois'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
