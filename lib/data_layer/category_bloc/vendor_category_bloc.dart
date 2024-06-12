
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'vendor_category_event.dart';
part 'vendor_category_state.dart';

class VendorCategoryBloc
    extends Bloc<VendorCategoryEvent, VendorCategoryState> {
  VendorCategoryBloc() : super(VendorCategoryInitial()) {
    on<PickImageEvent>(_onPickImageEvent);
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
        emit(ImagePickerError(message: 'Image Not Selected'));
      }
    } catch (e) {
      emit(ImagePickerError(message: 'Failed to pick image: $e'));
    }
  }
}
