part of 'vendor_category_bloc.dart';

@immutable
sealed class VendorCategoryEvent {}

class PickImageEvent extends VendorCategoryEvent {}

class UploadImageEvent extends VendorCategoryEvent {
  final String id;
  final String imageName;
  final Uint8List imageBytes;

  UploadImageEvent(
      {required this.id, required this.imageName, required this.imageBytes});
}

class ClearImageEvent extends VendorCategoryEvent {}
