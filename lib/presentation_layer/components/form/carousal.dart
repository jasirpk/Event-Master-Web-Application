import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/carousal.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/category/read_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarousalSliderWidget extends StatelessWidget {
  const CarousalSliderWidget({
    super.key,
    required this.documents,
    required this.databaseMethods,
    required this.screenWidth,
    required this.screenHeight,
  });

  final List<QueryDocumentSnapshot<Object?>> documents;
  final DatabaseMethods databaseMethods;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: documents.length,
      itemBuilder: (context, index, pageIndex) {
        var data = documents[index].data() as Map<String, dynamic>;
        String imagePath = data['imagePath'] ??
            'assets/images/Screenshot 2024-05-22 205021.png';
        String documentId = documents[index].id;

        return FutureBuilder<DocumentSnapshot>(
          future: databaseMethods.getCategoryDetailById(documentId),
          builder: (context, detailSnapshot) {
            if (detailSnapshot.connectionState == ConnectionState.waiting) {
              return ShimmerCarouselItem(
                  screenWidth: screenWidth, screenHeight: screenHeight);
            }
            if (!detailSnapshot.hasData) {
              return Center(
                child: Text(
                  'Details not found',
                ),
              );
            }
            var detailData =
                detailSnapshot.data!.data() as Map<String, dynamic>;

            return InkWell(
              onTap: () {
                Get.to(() => CategoryDetailScreen(categoryData: detailData));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF37474F),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imagePath.startsWith('http')
                        ? NetworkImage(imagePath)
                        : AssetImage(imagePath) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.teal),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3)),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            detailData['categoryName'] ?? 'No Name',
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.028,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) async {
                            if (value == 'View Detail') {
                              Get.to(
                                  () => CategoryDetailScreen(
                                      categoryData: detailData),
                                  transition: Transition.leftToRight);
                            } else if (value == 'delete') {
                              await databaseMethods
                                  .deleteVendorCategoryDeatail(documentId);
                              showCustomSnackBar('Deleted ⚠ ',
                                  'category deleted Successfully!');
                            }
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
          },
        );
      },
      options: CarouselOptions(
        height: 250,
        aspectRatio: 16 / 9,
        reverse: false,
        viewportFraction: 0.55,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 6),
        autoPlayAnimationDuration: Duration(seconds: 3),
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
