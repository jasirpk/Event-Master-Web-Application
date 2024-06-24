import 'dart:typed_data';
import 'package:event_master_web/data_layer/services/sub_category.dart';
import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class AddSubCategoryScreen extends StatelessWidget {
  final String categoryId;

  const AddSubCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    TextEditingController subCategoryNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    ValueNotifier<Uint8List?> selectedImageNotifier =
        ValueNotifier<Uint8List?>(null);
    ValueNotifier<String?> imageNameNotifier = ValueNotifier<String?>(null);
    String? subCategoryId;
    final bool? isEditing = false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Get started by adding a new sub-template \nFor Your Clients",
                      style: TextStyle(fontSize: screenHeight * 0.04),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: subCategoryNameController,
                      labelText: 'Type a sub-category Name',
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
                      initialImageUrl: 'assets/images/background_demo_img.png',
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedImageNotifier.value != null &&
                            subCategoryNameController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty) {
                          String? image = imageNameNotifier.value;
                          Uint8List? imageBytes = selectedImageNotifier.value;
                          String id = subCategoryId ?? randomAlphaNumeric(10);
                          Map<String, dynamic> subCategoryFields = {
                            'subCategoryName': subCategoryNameController.text,
                            'about': descriptionController.text,
                            'image': image,
                            'id': id,
                          };

                          if (image != null && imageBytes != null) {
                            try {
                              await SubDatabaseMethods()
                                  .addSubCategory(
                                categoryId,
                                id,
                                subCategoryFields,
                                imageBytes,
                                isEditing: isEditing ?? false,
                              )
                                  .then((value) {
                                print(
                                    'The sub categories are added successfully');
                                Fluttertoast.showToast(
                                  msg:
                                      'The sub-category details are ${isEditing == true ? 'updated' : 'added'} successfully',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                // Clear form fields and notifiers
                                subCategoryNameController.clear();
                                descriptionController.clear();
                                selectedImageNotifier.value = null;
                                imageNameNotifier.value = null;
                              });
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Error: $e",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please fill all the fields",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text('Submit'),
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
