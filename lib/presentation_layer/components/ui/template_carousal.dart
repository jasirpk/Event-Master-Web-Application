import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/database.dart';
import 'package:event_master_web/presentation_layer/components/ui/carousal.dart';
import 'package:event_master_web/presentation_layer/components/ui/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  TemplateCard(
    this.screenWidth,
    this.screenHeight,
  );

  final DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: const Color(0xFF263238), // Dark theme background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Add Templates',
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(RoutsClass.getFormRout());
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: databaseMethods.getVendorDetail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerLoadingEffect(
                        screenWidth: screenWidth, screenHeight: screenHeight);
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Flexible(
                        child: Text(
                          'No Templates Found',
                        ),
                      ),
                    );
                  }
                  var documents = snapshot.data!.docs;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CarousalSliderWidget(
                            documents: documents,
                            databaseMethods: databaseMethods,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
