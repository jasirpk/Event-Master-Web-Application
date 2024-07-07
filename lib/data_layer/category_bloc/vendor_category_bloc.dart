import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'vendor_category_event.dart';
part 'vendor_category_state.dart';

class VendorCategoryBloc
    extends Bloc<VendorCategoryEvent, VendorCategoryState> {
  final DatabaseMethods databaseMethods = DatabaseMethods();

  VendorCategoryBloc() : super(VendorCategoryInitial()) {
    on<PickImageEvent>(_onPickImageEvent);
    on<UploadImageEvent>(uploadImageEvent);
    on<ClearImageEvent>(clearImages);
  }

  Future<void> _onPickImageEvent(
      PickImageEvent event, Emitter<VendorCategoryState> emit) async {
    emit(ImagePickerLoading());

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? fileBytes = result.files.single.bytes;

        if (fileBytes != null) {
          emit(ImageSelected(fileBytes, result.files.single.name));
        } else {
          emit(ImagePickerError(message: 'Failed to get image bytes'));
        }
      } else {
        emit(ImagePickerError(message: 'Please Select the Image'));
      }
    } catch (e) {
      emit(ImagePickerError(message: 'Failed to pick image: $e'));
    }
  }

  FutureOr<void> uploadImageEvent(
      UploadImageEvent event, Emitter<VendorCategoryState> emit) async {
    emit(imageUploading());
    try {
      String? downloadUrl = await databaseMethods.uploadImage(
          event.id, event.imageName, event.imageBytes);
      emit(ImageUploadSuccess(downloadUrl!));
    } catch (e) {
      emit(ImageUploadError(message: 'Failed to Uploade image $e'));
    }
  }

  FutureOr<void> clearImages(
      ClearImageEvent event, Emitter<VendorCategoryState> emit) {
    emit(VendorCategoryInitial());
  }
}
