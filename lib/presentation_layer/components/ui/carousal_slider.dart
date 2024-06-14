import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/database.dart';
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
                Text(
                  'Add Templates',
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.toNamed(RoutsClass.getFormRout());
                    },
                    icon: Icon(Icons.add, color: Colors.white))
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: databaseMethods.getVendorDetail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Templates Found',
                        style: TextStyle(
                          color: Colors.white, // White text for consistency
                        ),
                      ),
                    );
                  }
                  var documents = snapshot.data!.docs;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index, pageIndex) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            String imagePath = data['imagePath'] ??
                                'assets/images/Screenshot 2024-05-22 205021.png';

                            return Container(
                              decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF37474F), // Another shade of grey
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imagePath.startsWith('http')
                                        ? NetworkImage(imagePath)
                                        : AssetImage(imagePath)
                                            as ImageProvider,
                                    fit: BoxFit
                                        .cover, // Changed to cover for better fit
                                  ),
                                  border: Border.all(color: Colors.teal)),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3)),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['categoryName'] ?? 'No Name',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenHeight * 0.028,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      PopupMenuButton(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            Get.toNamed(
                                                RoutsClass.getEditCategory());
                                          } else if (value == 'delete') {}
                                        },
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              child: Text('Edit'),
                                              value: 'edit',
                                            ),
                                            PopupMenuItem(
                                              child: Text('Delete'),
                                              value: 'delete',
                                            )
                                          ];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            aspectRatio: 16 / 9,
                            reverse: false,
                            viewportFraction: 0.55,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(seconds: 1),
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
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
