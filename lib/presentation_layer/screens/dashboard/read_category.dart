import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/ui/category_detail.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/components/ui/sub_category_widget.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/add_sub_category.dart';
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
              CategoryDetailWidget(
                screenHeight: screenHeight,
                categoryData: categoryData,
                documentId: documentId,
                databaseMethods: databaseMethods,
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
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Sub-Templates',
                        style: TextStyle(
                          fontSize: screenHeight * 0.026,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(
                              () => AddSubCategoryScreen(
                                    categoryId: documentId,
                                  ),
                              transition: Transition.fade,
                              duration: Duration(milliseconds: 800));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: myColor),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Add Templates',
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.022,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Icon(Icons.add)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: SubCategoryWidget(
                  templateId: documentId,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
