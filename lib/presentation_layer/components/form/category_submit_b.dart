import 'dart:typed_data';
import 'package:event_master_web/common/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:event_master_web/data_layer/services/category.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController categoryNameController;
  final TextEditingController descriptionController;
  final ValueNotifier<String?> selectedClientNotifier;
  final ValueNotifier<Uint8List?> selectedImageNotifier;
  final ValueNotifier<String?> imageNameNotifier;
  final String? categoryId;
  final bool? isEditing;

  SubmitButton({
    required this.categoryNameController,
    required this.descriptionController,
    required this.selectedClientNotifier,
    required this.selectedImageNotifier,
    required this.imageNameNotifier,
    this.categoryId,
    this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () async {
          // Check if all required fields are filled
          if (selectedImageNotifier.value != null &&
              selectedClientNotifier.value != null &&
              categoryNameController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty) {
            String? imagePath = imageNameNotifier.value;
            Uint8List? imageBytes = selectedImageNotifier.value;
            String id = categoryId ?? randomAlphaNumeric(10);
            Map<String, dynamic> categoryFields = {
              'value': selectedClientNotifier.value,
              'categoryName': categoryNameController.text,
              'description': descriptionController.text,
              'id': id,
              'imagePath': imagePath,
            };

            if (imagePath != null && imageBytes != null) {
              await DatabaseMethods()
                  .addVendorCategoryDetail(
                categoryFields,
                id,
                'Categories/$id/$imagePath',
                imageBytes,
                isEditing: isEditing ?? false,
              )
                  .then((value) {
                Fluttertoast.showToast(
                  msg:
                      "The Category Details are ${isEditing == true ? 'updated' : 'added'} successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                // Clear the text fields and notifiers after submission
                categoryNameController.clear();
                descriptionController.clear();
                selectedClientNotifier.value = null;
                selectedImageNotifier.value = null;
                imageNameNotifier.value = null;
              });
            }
          } else {
            Fluttertoast.showToast(
              msg: "Please fill all the fields",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
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
