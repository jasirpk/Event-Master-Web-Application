import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/edit_category.dart';
import 'package:event_master_web/data_layer/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> categoryData;

  CategoryDetailScreen({required this.categoryData});

  final DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseMethods.getVendorDetail(),
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

          var documentId = categoryData['id'];
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.6,
                flexibleSpace: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(categoryData['imagePath']),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.1),
                            BlendMode.color,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Get.to(() => UpdateScreen(
                                  id: documentId,
                                  categoryData: categoryData,
                                ));
                          } else if (value == 'delete') {
                            await databaseMethods
                                .deleteVendorCategoryDeatail(documentId);
                            Get.back();
                            showCustomSnackBar(
                                'Deleted ⚠ ', 'category deleted Successfully!');
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
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryData['categoryName'],
                            style: TextStyle(
                              fontFamily: 'JacquesFracois',
                              fontSize: screenHeight * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 12, top: 12),
                  child: Row(
                    children: [
                      Text(
                        'Author:',
                        style: TextStyle(
                          fontFamily: 'JacquesFracois',
                          color: Colors.blue,
                          fontSize: screenHeight * 0.022,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        categoryData['value'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.022,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    categoryData['description'],
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
        },
      ),
    );
  }
}
