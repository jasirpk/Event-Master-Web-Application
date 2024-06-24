import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryDetailScreen extends StatelessWidget {
  final String categoryId;
  final Map<String, dynamic> subCategoryData;
  final SubDatabaseMethods subDatabaseMethods = SubDatabaseMethods();

  SubCategoryDetailScreen(
      {super.key, required this.categoryId, required this.subCategoryData});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: subDatabaseMethods.getSubCategories(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Templates Found'),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: screenHeight * 0.6,
                  flexibleSpace: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(subCategoryData['imagePath']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.1), BlendMode.color),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              // Navigate to edit screen
                            } else if (value == 'delete') {
                              await subDatabaseMethods.deleteSubCategory(
                                  categoryId, subCategoryData['id']);
                              Get.back();
                              showCustomSnackBar('Deleted ⚠ ',
                                  'Category deleted successfully!');
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subCategoryData['subCategoryName'],
                          style: TextStyle(
                            fontFamily: 'JacquesFracois',
                            fontSize: screenHeight * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Additional details here
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      subCategoryData['about'],
                      style: TextStyle(
                        textBaseline: TextBaseline.ideographic,
                        fontWeight: FontWeight.w300,
                        fontSize: screenHeight * 0.022,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
