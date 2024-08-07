import 'dart:typed_data';

import 'package:event_master_web/data_layer/category_bloc/vendor_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageSelector extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final ValueNotifier<Uint8List?> selectedImageNotifier;
  final ValueNotifier<String?> imageNameNotifier;
  final String? initialImageUrl;

  ImageSelector({
    required this.screenWidth,
    required this.screenHeight,
    required this.selectedImageNotifier,
    required this.imageNameNotifier,
    this.initialImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCategoryBloc, VendorCategoryState>(
      builder: (context, state) {
        if (state is ImagePickerLoading) {
          return CircularProgressIndicator();
        } else if (state is ImageSelected) {
          selectedImageNotifier.value = state.imageBytes;
          imageNameNotifier.value = state.imageName;
        } else if (state is ImagePickerError) {
          return ElevatedButton(
            onPressed: () {
              context.read<VendorCategoryBloc>().add(PickImageEvent());
            },
            style: ButtonStyle(
              side: WidgetStateProperty.all<BorderSide>(
                BorderSide(color: Colors.teal, width: 2.0),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: Text('Change Image'),
          );
        }

        return ValueListenableBuilder<Uint8List?>(
          valueListenable: selectedImageNotifier,
          builder: (context, imageBytes, child) {
            return Column(
              children: [
                imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.3,
                      )
                    : initialImageUrl != null
                        ? Image.network(
                            initialImageUrl!,
                            fit: BoxFit.cover,
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.3,
                          )
                        : Container(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                SizedBox(height: 10),
                if (imageNameNotifier.value != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('File name: ${imageNameNotifier.value}'),
                      SizedBox(width: 10),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    context.read<VendorCategoryBloc>().add(PickImageEvent());
                  },
                  style: ButtonStyle(
                    side: WidgetStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text('Pick Image'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
