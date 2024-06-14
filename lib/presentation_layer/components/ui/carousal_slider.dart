import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/database.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/edit_category.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/read_category.dart';
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Flexible(
                        child: Text(
                          'No Templates Found',
                          style: TextStyle(
                            color: Colors.white, // White text for consistency
                          ),
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
                            String documentId = documents[index].id;

                            return FutureBuilder<DocumentSnapshot>(
                              future: databaseMethods
                                  .getCategoryDetailById(documentId),
                              builder: (context, detailSnapshot) {
                                if (detailSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!detailSnapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      'Details not found',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                                var detailData = detailSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryDetailScreen(
                                          categoryData: detailData,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF37474F),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: imagePath.startsWith('http')
                                              ? NetworkImage(imagePath)
                                              : AssetImage(imagePath)
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(color: Colors.teal),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 8, top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  detailData['categoryName'] ??
                                                      'No Name',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenHeight * 0.028,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton(
                                                onSelected: (value) async {
                                                  if (value == 'edit') {
                                                    Get.to(() => UpdateScreen(
                                                        id: documentId,
                                                        categoryData:
                                                            detailData));
                                                  } else if (value ==
                                                      'delete') {
                                                    await databaseMethods
                                                        .deleteVendorCategoryDeatail(
                                                            documentId);
                                                    showCustomSnackBar(
                                                        'Deleted ⚠ ',
                                                        'category deleted Successfully!');
                                                  }
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
                                                    ),
                                                  ];
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            aspectRatio: 16 / 9,
                            reverse: false,
                            viewportFraction: 0.55,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            // autoPlay: true,
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
