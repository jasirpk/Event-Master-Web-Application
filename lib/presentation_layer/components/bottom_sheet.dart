import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:event_master_web/bussiness_layer/repos/expand_widget.dart';
import 'package:event_master_web/bussiness_layer/repos/preview_widget.dart';
import 'package:event_master_web/common/style.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
        minExtent: 120,
        useSafeArea: false,
        curve: Curves.easeIn,
        previewWidget: previewWidget(),
        backgroundWidget: sizedBox,
        expandedWidget: expandWidget(),
        maxExtent: MediaQuery.of(context).size.height * 0.6,
        onDragging: (pos) {});
  }
}
