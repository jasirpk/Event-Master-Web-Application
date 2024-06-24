import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/edit_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailWidget extends StatelessWidget {
  const CategoryDetailWidget({
    super.key,
    required this.screenHeight,
    required this.categoryData,
    required this.documentId,
    required this.databaseMethods,
  });

  final double screenHeight;
  final Map<String, dynamic> categoryData;
  final documentId;
  final DatabaseMethods databaseMethods;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                  await databaseMethods.deleteVendorCategoryDeatail(documentId);
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
    );
  }
}
