@TestOn('browser')
library;

import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/ui/vendor_review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Browser-only: the card reaches MediaImage, whose media service imports
/// `package:http/browser_client.dart`, which cannot compile for the VM.
/// Run with: flutter test --platform chrome test/vendor_review_card_test.dart
///
/// Firestore is never reached. [VendorRequest.setVendorDecision] is overridden
/// below, which is what lets the full in-flight, success and failure paths be
/// exercised without a Firestore fake — the harness has none.

/// A write whose timing and outcome the test controls.
class FakeVendorRequest extends VendorRequest {
  FakeVendorRequest({this.fail = false, this.onWritten});

  final bool fail;
  final void Function(String vendorId)? onWritten;

  final List<Map<String, Object>> writes = [];

  @override
  Future<void> setVendorDecision(String uid, String vendorId,
      {required bool accepted}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (fail) throw Exception('network unreachable');

    writes.add({'uid': uid, 'vendorId': vendorId, 'accepted': accepted});
    onWritten?.call(vendorId);
  }
}

/// The app's theme, from main.dart.
ThemeData appTheme() => ThemeData(
      brightness: Brightness.dark,
      textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white)),
    ).copyWith();

Map<String, dynamic> vendor({
  String id = 'v1',
  bool accepted = false,
  bool rejected = false,
}) =>
    {
      'categoryName': 'Listing $id',
      'description': 'Full service catering for weddings and corporate events.',
      'location': 'Kozhikode, Kerala',
      'imagePathUrl': '',
      'images': <dynamic>[],
      'budget': {'from': 25000, 'to': 90000},
      'isValid': true,
      'isAccepted': accepted,
      'isRejected': rejected,
    };

Future<void> pumpCard(
  WidgetTester tester,
  Map<String, dynamic> data,
  VendorRequest request,
) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(
    theme: appTheme(),
    home: Scaffold(
      body: ListView(children: [
        VendorReviewCard(
          uid: 'uid123',
          vendorId: 'v1',
          vendorDetail: data,
          vendorRequest: request,
        ),
      ]),
    ),
  ));
  await tester.pump();
}

Future<void> confirm(WidgetTester tester, String action) async {
  await tester.tap(find.widgetWithText(ElevatedButton, action));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(FilledButton, action));
}

void main() {
  group('actions follow the listing status, not the tab', () {
    testWidgets('a pending listing offers both', (tester) async {
      await pumpCard(tester, vendor(), FakeVendorRequest());
      expect(find.widgetWithText(ElevatedButton, 'Accept'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Reject'), findsOneWidget);
    });

    testWidgets('an accepted listing offers only Reject', (tester) async {
      await pumpCard(tester, vendor(accepted: true), FakeVendorRequest());
      expect(find.widgetWithText(ElevatedButton, 'Accept'), findsNothing);
      expect(find.widgetWithText(ElevatedButton, 'Reject'), findsOneWidget);
    });

    testWidgets('a rejected listing offers only Accept', (tester) async {
      await pumpCard(tester, vendor(rejected: true), FakeVendorRequest());
      expect(find.widgetWithText(ElevatedButton, 'Accept'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Reject'), findsNothing);
    });
  });

  testWidgets('cancelling writes nothing', (tester) async {
    final request = FakeVendorRequest();
    await pumpCard(tester, vendor(), request);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Accept'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(request.writes, isEmpty);
    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsOneWidget);
  });

  testWidgets('accepting writes both flags for the right document',
      (tester) async {
    final request = FakeVendorRequest();
    await pumpCard(tester, vendor(), request);

    await confirm(tester, 'Accept');
    await tester.pumpAndSettle();

    expect(request.writes.single,
        {'uid': 'uid123', 'vendorId': 'v1', 'accepted': true});
  });

  testWidgets('rejecting writes the opposite decision', (tester) async {
    final request = FakeVendorRequest();
    await pumpCard(tester, vendor(), request);

    await confirm(tester, 'Reject');
    await tester.pumpAndSettle();

    expect(request.writes.single['accepted'], false);
  });

  testWidgets('the in-flight state paints and blocks a second tap',
      (tester) async {
    final request = FakeVendorRequest();
    await pumpCard(tester, vendor(), request);

    await confirm(tester, 'Accept');
    await tester.pump();

    expect(find.text('Saving…'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsNothing,
        reason: 'buttons are replaced while the write is in flight');

    await tester.pumpAndSettle();
    expect(request.writes, hasLength(1));
  });

  testWidgets('a failed write keeps the listing and reports the reason',
      (tester) async {
    final request = FakeVendorRequest(fail: true);
    await pumpCard(tester, vendor(), request);

    await confirm(tester, 'Accept');
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not accept'), findsOneWidget);
    expect(find.textContaining('network unreachable'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsOneWidget,
        reason: 'the listing must not move when the write failed');
  });

  testWidgets('feedback survives the card being disposed by its stream',
      (tester) async {
    // The real stream removes an accepted listing from the tab, disposing the
    // card that started the write. The confirmation still has to appear.
    late StateSetter setOuter;
    var present = true;

    final request = FakeVendorRequest(onWritten: (_) {
      setOuter(() => present = false);
    });

    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      theme: appTheme(),
      home: Scaffold(
        body: StatefulBuilder(builder: (context, setState) {
          setOuter = setState;
          return ListView(children: [
            if (present)
              VendorReviewCard(
                uid: 'uid123',
                vendorId: 'v1',
                vendorDetail: vendor(),
                vendorRequest: request,
              ),
          ]);
        }),
      ),
    ));
    await tester.pump();

    await confirm(tester, 'Accept');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Accept'), findsNothing,
        reason: 'card removed by the stream');
    expect(find.textContaining('Listing accepted'), findsOneWidget);
  });
}
