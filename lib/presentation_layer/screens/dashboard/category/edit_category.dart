import 'dart:typed_data';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/components/auth/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/drop_down.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> categoryData;

  const UpdateScreen({super.key, required this.id, required this.categoryData});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    TextEditingController categoryNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    ValueNotifier<String?> selectedClientNotifier =
        ValueNotifier<String?>(null);
    ValueNotifier<Uint8List?> selectedImageNotifier =
        ValueNotifier<Uint8List?>(null);
    ValueNotifier<String?> imageNameNotifier = ValueNotifier<String?>(null);

    categoryNameController.text = widget.categoryData['categoryName'];
    descriptionController.text = widget.categoryData['description'];
    @override
    void dispose() {
      selectedImageNotifier.dispose();
      imageNameNotifier.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(RoutsClass.getHomeRout());
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
                padding: EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Get started by adding a new template \nFor Your Clients",
                      style: TextStyle(fontSize: screenHeight * 0.04),
                    ),
                    SizedBox(height: 20),
                    ClientDropdown(
                      selectedClientNotifier: selectedClientNotifier,
                      InitialValue: widget.categoryData['value'],
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: categoryNameController,
                      labelText: 'Type a Category Name',
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
                      initialImageUrl: widget.categoryData['imagePath'],
                    ),
                    SizedBox(height: 40),
                    pushableButton_Widget(
                      onPressed: () async {
                        String? newImagePath = widget.categoryData['imagePath'];
                        if (selectedImageNotifier.value != null) {
                          // New image was selected
                          Uint8List imageBytes = selectedImageNotifier.value!;
                          String imageName = imageNameNotifier.value ?? '';
                          newImagePath = await DatabaseMethods()
                              .uploadImage(widget.id, imageName, imageBytes);
                        }

                        Map<String, dynamic> updatedData = {
                          'categoryName': categoryNameController.text,
                          'description': descriptionController.text,
                          'value': selectedClientNotifier.value ??
                              widget.categoryData['value'],
                          'imagePath': newImagePath,
                        };

                        await DatabaseMethods()
                            .updateVendorCategoryDetail(widget.id, updatedData);

                        // Clear the fields
                        categoryNameController.clear();
                        descriptionController.clear();
                        selectedClientNotifier.value = null;
                        selectedImageNotifier.value = null;
                        imageNameNotifier.value = null;
                      },
                      text: 'Update',
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
