import 'dart:typed_data';

import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/drop_down.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:event_master_web/presentation_layer/components/form/submit_button.dart';
import 'package:flutter/material.dart';

class AddeTemplateScreen extends StatelessWidget {
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
                      "Get started by adding a new template \nFor Your Clients",
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
