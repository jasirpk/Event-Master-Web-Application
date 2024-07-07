import 'dart:typed_data';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/services/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class subCategorySubmitButton extends StatelessWidget {
  const subCategorySubmitButton({
    super.key,
    required this.selectedImageNotifier,
    required this.subCategoryNameController,
    required this.descriptionController,
    required this.imageNameNotifier,
    required this.subCategoryId,
    required this.categoryId,
    required this.isEditing,
  });

  final ValueNotifier<Uint8List?> selectedImageNotifier;
  final TextEditingController subCategoryNameController;
  final TextEditingController descriptionController;
  final ValueNotifier<String?> imageNameNotifier;
  final String? subCategoryId;
  final String categoryId;
  final bool? isEditing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () async {
          bool isFavorite = false;
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
                  print('The sub categories are added successfully');
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
        style: ElevatedButton.styleFrom(
          backgroundColor: myColor,
          shadowColor: Colors.tealAccent, // Shadow color
          elevation: 5, // Elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
        ),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
