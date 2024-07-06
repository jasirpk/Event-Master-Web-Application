import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/entrepreneurs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/category/read_category.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({
    super.key,
    required this.databaseMethods,
    required this.screenWidth,
    required this.screenHeight,
    required this.value,
  });

  final DatabaseMethods databaseMethods;
  final double screenWidth;
  final double screenHeight;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: databaseMethods.getVendorDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerEntrepreneurs(
                screenHeight: screenHeight, screenWidth: screenWidth);
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Templates Found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          var documents = snapshot.data!.docs;
          var filteredDocuments = documents.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['value'] == value;
          }).toList();
          if (filteredDocuments.isEmpty) {
            return Center(
              child: Text(
                'No Templates Found for $value', // Provide feedback for no matching documents
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 3,
            itemCount: filteredDocuments.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemBuilder: (context, index) {
              var data =
                  filteredDocuments[index].data() as Map<String, dynamic>;
              String imagePath = data['imagePath'] ??
                  'assets/images/Screenshot 2024-05-22 205021.png';
              String documentId = filteredDocuments[index].id;

              return FutureBuilder<DocumentSnapshot>(
                future: databaseMethods.getCategoryDetailById(documentId),
                builder: (context, detailSnapshot) {
                  if (detailSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ShimmerEntrepreneurs(
                        screenHeight: screenHeight, screenWidth: screenWidth);
                  }
                  if (!detailSnapshot.hasData) {
                    return Center(
                      child: Text(
                        'Details not found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  var detailData =
                      detailSnapshot.data!.data() as Map<String, dynamic>;

                  return InkWell(
                    onTap: () {
                      Get.to(
                          () => CategoryDetailScreen(categoryData: detailData));
                    },
                    child: Container(
                      height: screenHeight * 0.3,
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
                                    color: Colors.white,
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
                                        .deleteVendorCategoryDeatail(
                                            documentId);
                                    showCustomSnackBar('Deleted ⚠',
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
          );
        },
      ),
    );
  }
}
