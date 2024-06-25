import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/category/entrepreneur_list.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/category/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SilverStackAppBar extends StatelessWidget {
  SilverStackAppBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;
  final DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: databaseMethods.getVendorDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('No Templates Found'),
            ),
          );
        }
        // var documts = snapshot.data!.docs;
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
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Screenshot 2024-05-22 205021.png'),
                                fit: BoxFit.cover,
                              ),
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
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => EntrepreneurListScreen(
                                              screenWidth,
                                              screenHeight,
                                              'Entrepreneur'));
                                        },
                                        child: CircleAvatar(
                                          maxRadius: screenHeight * 0.06,
                                          backgroundImage: AssetImage(
                                            'assets/images/google_ath_img.jpg',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Entrepreneur',
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.03,
                                          fontFamily: 'JacquesFracois',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Screenshot 2024-05-22 205021.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                border:
                                    Border.all(color: Colors.teal, width: 3),
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
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => UserListScreen(
                                                screenWidth,
                                                screenHeight,
                                                'Client'));
                                          },
                                          child: CircleAvatar(
                                            maxRadius: screenHeight * 0.06,
                                            backgroundImage: AssetImage(
                                              'assets/images/clint_login_background.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'User',
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.03,
                                            fontFamily: 'JacquesFracois',
                                          ),
                                        ),
                                      ),
                                    ],
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
      },
    );
  }
}
