import 'dart:typed_data';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/sub_category.dart';
import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSubCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final Map<String, dynamic> subCategoryData;

  const EditSubCategoryScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.subCategoryData,
  });

  @override
  State<EditSubCategoryScreen> createState() => _EditSubCategoryScreenState();
}

class _EditSubCategoryScreenState extends State<EditSubCategoryScreen> {
  final TextEditingController subCategoryNameController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<Uint8List?> selectedImageNotifier =
      ValueNotifier<Uint8List?>(null);
  final ValueNotifier<String?> imageNameNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    subCategoryNameController.text =
        widget.subCategoryData['subCategoryName'] ?? '';
    descriptionController.text = widget.subCategoryData['about'] ?? '';
  }

  @override
  void dispose() {
    subCategoryNameController.dispose();
    descriptionController.dispose();
    selectedImageNotifier.dispose();
    imageNameNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(RoutsClass.getHomeRout());
          },
          icon: Icon(Icons.close),
        ),
        title: Text('Edit SubCategory'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Edit the sub-category details below",
                      style: TextStyle(fontSize: screenHeight * 0.04),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: subCategoryNameController,
                      labelText: 'Category Name',
                      icon: Icons.list_alt,
                    ),
                    SizedBox(height: 40),
                    CustomTextField(
                      controller: descriptionController,
                      labelText: 'Description',
                      maxLines: 4,
                      alignLabelWithHint: true,
                    ),
                    SizedBox(height: 40),
                    ImageSelector(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      selectedImageNotifier: selectedImageNotifier,
                      imageNameNotifier: imageNameNotifier,
                      initialImageUrl:
                          widget.subCategoryData['imagePath'] ?? '',
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        child: Text('Update SubCategory'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          textStyle: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          String? newImagePath =
                              widget.subCategoryData['imagePath'];
                          if (selectedImageNotifier.value != null) {
                            Uint8List imageBytes = selectedImageNotifier.value!;
                            String imageName = imageNameNotifier.value ?? '';
                            newImagePath = await SubDatabaseMethods()
                                .uploadImage(widget.subCategoryId, imageName,
                                    imageBytes);
                          }
                          Map<String, dynamic> subCategoryFields = {
                            'subCategoryName': subCategoryNameController.text,
                            'about': descriptionController.text,
                            'imagePath': newImagePath,
                          };

                          await SubDatabaseMethods().updateSubCategory(
                              widget.categoryId,
                              widget.subCategoryId,
                              subCategoryFields);
                        },
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  child: Image.asset(
                    'assets/images/all_projects_right_image.png',
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
