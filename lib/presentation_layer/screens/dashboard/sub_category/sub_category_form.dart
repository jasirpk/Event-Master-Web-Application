import 'dart:typed_data';
import 'package:event_master_web/data_layer/category_bloc/vendor_category_bloc.dart';
import 'package:event_master_web/presentation_layer/components/form/custom_textfield.dart';
import 'package:event_master_web/presentation_layer/components/form/image_selector.dart';
import 'package:event_master_web/presentation_layer/components/form/sub_category_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSubCategoryScreen extends StatefulWidget {
  final String categoryId;

  const AddSubCategoryScreen({super.key, required this.categoryId});

  @override
  State<AddSubCategoryScreen> createState() => _AddSubCategoryScreenState();
}

class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
  VendorCategoryBloc? _vendorCategoryBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _vendorCategoryBloc = context.read<VendorCategoryBloc>();
  }

  @override
  void dispose() {
    _vendorCategoryBloc?.add(ClearImageEvent());
    super.dispose();
  }

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
                    subCategorySubmitButton(
                        selectedImageNotifier: selectedImageNotifier,
                        subCategoryNameController: subCategoryNameController,
                        descriptionController: descriptionController,
                        imageNameNotifier: imageNameNotifier,
                        subCategoryId: subCategoryId,
                        categoryId: widget.categoryId,
                        isEditing: isEditing),
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
