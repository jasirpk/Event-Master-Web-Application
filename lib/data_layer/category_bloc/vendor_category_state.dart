part of 'vendor_category_bloc.dart';

@immutable
sealed class VendorCategoryState {}

final class VendorCategoryInitial extends VendorCategoryState {}

class ImagePickerLoading extends VendorCategoryState {}

class ImageSelected extends VendorCategoryState {
  final Uint8List imageBytes;
  final String imageName;

  ImageSelected(this.imageBytes, this.imageName);
}

class ImagePickerError extends VendorCategoryState {
  final String message;

  ImagePickerError({required this.message});
}

class imageUploading extends VendorCategoryState {}

class ImageUploadSuccess extends VendorCategoryState {
  final String imageUrl;

  ImageUploadSuccess(this.imageUrl);
}

class ImageUploadError extends VendorCategoryState {
  final String message;

  ImageUploadError({required this.message});
}
