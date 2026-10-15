import 'package:event_master_web/data_layer/models/vendor_document.dart';
import 'package:flutter_test/flutter_test.dart';

/// The flag pair `VendorRequest.setVendorDecision` writes.
///
/// Restated here rather than imported because the method itself reaches
/// Firestore, which this suite has no way to stand up. What is being pinned
/// is the rule the three tabs depend on: the two flags are one tri-state,
/// written together.
Map<String, dynamic> decisionWrite({required bool accepted}) =>
    {'isAccepted': accepted, 'isRejected': !accepted};

/// The three Checklist queries, as predicates.
bool inRequests(Map<String, dynamic> d) =>
    d['isValid'] == true && d['isAccepted'] == false && d['isRejected'] == false;
bool inAccepted(Map<String, dynamic> d) => d['isAccepted'] == true;
bool inRejected(Map<String, dynamic> d) => d['isRejected'] == true;

void main() {
  group('vendorDecisionOf', () {
    test('a freshly submitted listing is pending', () {
      expect(
        vendorDecisionOf({'isValid': true, 'isAccepted': false, 'isRejected': false}),
        VendorDecision.pending,
      );
    });

    test('reads accepted and rejected', () {
      expect(vendorDecisionOf({'isAccepted': true, 'isRejected': false}),
          VendorDecision.accepted);
      expect(vendorDecisionOf({'isAccepted': false, 'isRejected': true}),
          VendorDecision.rejected);
    });

    test('a legacy document with both flags resolves to one state', () {
      // Written before the two were always set together. It must not read as
      // accepted in one place and rejected in another.
      expect(vendorDecisionOf({'isAccepted': true, 'isRejected': true}),
          VendorDecision.rejected);
    });

    test('absent decision fields read as pending, not as a crash', () {
      expect(vendorDecisionOf({}), VendorDecision.pending);
      expect(vendorDecisionOf({'isAccepted': null, 'isRejected': null}),
          VendorDecision.pending);
    });

    test('a non-boolean never counts as a decision', () {
      expect(vendorDecisionOf({'isAccepted': 'true'}), VendorDecision.pending);
      expect(vendorDecisionOf({'isAccepted': 1}), VendorDecision.pending);
    });
  });

  group('the decision write', () {
    test('accepting lands the listing in Accepted alone', () {
      final doc = {'isValid': true, ...decisionWrite(accepted: true)};

      expect(vendorDecisionOf(doc), VendorDecision.accepted);
      expect(inAccepted(doc), isTrue);
      expect(inRequests(doc), isFalse);
      expect(inRejected(doc), isFalse);
    });

    test('rejecting lands the listing in Rejected alone', () {
      final doc = {'isValid': true, ...decisionWrite(accepted: false)};

      expect(vendorDecisionOf(doc), VendorDecision.rejected);
      expect(inRejected(doc), isTrue);
      expect(inRequests(doc), isFalse);
      expect(inAccepted(doc), isFalse);
    });

    test('every transition leaves the listing in exactly one tab', () {
      for (final accepted in [true, false]) {
        final doc = {'isValid': true, ...decisionWrite(accepted: accepted)};
        final tabs = [inRequests(doc), inAccepted(doc), inRejected(doc)]
            .where((present) => present)
            .length;

        expect(tabs, 1, reason: 'accepted=$accepted landed in $tabs tabs');
      }
    });

    test('the write never carries entrepreneur or listing validity', () {
      // Vendor acceptance and entrepreneur approval are separate decisions
      // that share a field name. The write must name neither.
      for (final accepted in [true, false]) {
        expect(decisionWrite(accepted: accepted).keys,
            unorderedEquals(['isAccepted', 'isRejected']));
      }
    });
  });

  group('vendorBudget', () {
    test('accepts the int/double mix firebase-admin produces', () {
      // A whole number written by the Media API comes back as an integer, so
      // Map<String,double>.from would throw here.
      expect(vendorBudget({'from': 25000, 'to': 90000.5}),
          {'from': 25000.0, 'to': 90000.5});
    });

    test('a missing or malformed budget yields zeros rather than throwing', () {
      expect(vendorBudget(null), {'from': 0.0, 'to': 0.0});
      expect(vendorBudget('nonsense'), {'from': 0.0, 'to': 0.0});
      expect(vendorBudget({}), {'from': 0.0, 'to': 0.0});
      expect(vendorBudget({'from': 'x', 'to': null}), {'from': 0.0, 'to': 0.0});
    });

    test('parses numeric strings', () {
      expect(vendorBudget({'from': '1500', 'to': '2500.75'}),
          {'from': 1500.0, 'to': 2500.75});
    });
  });

  group('vendorImages', () {
    test('tolerates a missing or malformed field', () {
      expect(vendorImages(null), isEmpty);
      expect(vendorImages('not a list'), isEmpty);
    });

    test('keeps the map entries and drops the junk', () {
      expect(
        vendorImages([
          {'text': 'Stage', 'imagePath': 'vendor_images/u/v/1.jpg'},
          'junk',
          42,
        ]).length,
        1,
      );
    });
  });

  group('vendorImageRef', () {
    test('prefers the R2 key written since the migration', () {
      expect(
        vendorImageRef({
          'imagePath': 'vendor_images/u/v/1.jpg',
          'imageUrl': 'https://legacy.example/old.jpg',
        }),
        'vendor_images/u/v/1.jpg',
      );
    });

    test('falls back to a legacy Firebase Storage URL', () {
      expect(vendorImageRef({'imageUrl': 'https://legacy.example/old.jpg'}),
          'https://legacy.example/old.jpg');
    });

    test('returns null when neither field is usable', () {
      expect(vendorImageRef({}), isNull);
      expect(vendorImageRef({'imagePath': '   ', 'imageUrl': ''}), isNull);
      expect(vendorImageRef({'imagePath': 42}), isNull);
    });
  });

  group('text helpers', () {
    test('a non-string field reads as empty, never a failed cast', () {
      expect(vendorText(null), '');
      expect(vendorText(42), '');
      expect(vendorText('Catering'), 'Catering');
      expect(vendorImageCaption({'text': null}), '');
      expect(vendorImageCaption({'text': 'Stage'}), 'Stage');
    });
  });
}
