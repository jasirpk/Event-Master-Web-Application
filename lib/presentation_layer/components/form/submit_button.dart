import 'dart:typed_data';
import 'package:event_master_web/data_layer/services/database.dart';
import 'package:event_master_web/presentation_layer/components/auth/pushable_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController categoryNameController;
  final TextEditingController descriptionController;
  final ValueNotifier<String?> selectedClientNotifier;
  final ValueNotifier<Uint8List?> selectedImageNotifier;
  final ValueNotifier<String?> imageNameNotifier;

  SubmitButton({
    required this.categoryNameController,
    required this.descriptionController,
    required this.selectedClientNotifier,
    required this.selectedImageNotifier,
    required this.imageNameNotifier,
    String? categoryId,
    bool? isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return pushableButton_Widget(
      onPressed: () async {
        // Check if an image is selected
        if (selectedImageNotifier.value != null) {
          String? imagePath = imageNameNotifier.value;
          Uint8List? imageBytes = selectedImageNotifier.value;
          String id = randomAlphaNumeric(10);
          Map<String, dynamic> categoryFields = {
            'value': selectedClientNotifier.value,
            'categoryName': categoryNameController.text,
            'description': descriptionController.text,
            'id': id,
            'imagePath': imagePath
          };

          if (imagePath != null && imageBytes != null) {
            await DatabaseMethods()
                .addVendorCategoryDetail(
              categoryFields,
              id,
              'categories/$id/$imagePath',
              imageBytes, // Passing imageBytes to the method
            )
                .then((value) {
              Fluttertoast.showToast(
                msg: "The Category Details are added Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              // Clear the text fields, selected client, and image
              categoryNameController.clear();
              descriptionController.clear();
              selectedClientNotifier.value = null;
              selectedImageNotifier.value = null;
              imageNameNotifier.value = null;
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: "Please select an image",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      text: 'Submit',
    );
  }
}
