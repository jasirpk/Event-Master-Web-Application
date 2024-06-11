import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vendor_category_event.dart';
part 'vendor_category_state.dart';

class VendorCategoryBloc extends Bloc<VendorCategoryEvent, VendorCategoryState> {
  VendorCategoryBloc() : super(VendorCategoryInitial()) {
    on<VendorCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
