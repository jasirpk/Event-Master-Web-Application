import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/drop_down.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:event_master_web/presentation_layer/components/form/submit_button.dart';
import 'package:flutter/material.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;

  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<String?> selectedClientNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<Uint8List?> selectedImageNotifier =
      ValueNotifier<Uint8List?>(null);
  final ValueNotifier<String?> imageNameNotifier = ValueNotifier<String?>(null);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.categoryId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        categoryNameController.text = data?['name'] ?? '';
        descriptionController.text = data?['description'] ?? '';
        selectedClientNotifier.value = data?['client'] ?? '';
        // Load image if needed
        // Note: You may need to adjust this based on your image handling
      }
    } catch (e) {
      log('Error loading category data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            "Edit the category details below",
                            style: TextStyle(fontSize: screenHeight * 0.04),
                          ),
                          SizedBox(height: 20),
                          ClientDropdown(
                              selectedClientNotifier: selectedClientNotifier),
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
                          ),
                          SizedBox(height: 40),
                          SubmitButton(
                            categoryNameController: categoryNameController,
                            descriptionController: descriptionController,
                            selectedClientNotifier: selectedClientNotifier,
                            selectedImageNotifier: selectedImageNotifier,
                            imageNameNotifier: imageNameNotifier,
                            categoryId: widget.categoryId,
                            isEditing: true,
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
                      )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
