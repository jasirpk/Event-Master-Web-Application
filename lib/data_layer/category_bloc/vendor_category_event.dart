part of 'vendor_category_bloc.dart';

@immutable
sealed class VendorCategoryEvent {}

class PickImageEvent extends VendorCategoryEvent {}

class UploadImageEvent extends VendorCategoryEvent {
  final String id;
  final String imageName;
  final Uint8List imageBytes;

  UploadImageEvent(this.id, this.imageName, this.imageBytes);
}
