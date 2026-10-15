/// Reading a `entrepreneurs/{uid}/vendorDetails/{vendorId}` document.
///
/// These documents have been written by two different clients, and the
/// differences between them are the kind that fail at runtime rather than at
/// compile time — so they are handled here once instead of at every call site.

/// A numeric field from Firestore, as a Dart double.
///
/// Firestore distinguishes integers from doubles on the wire. The old vendor
/// form sent Dart doubles, which always stored as `doubleValue`; the Media
/// API sends numbers parsed from JSON, and firebase-admin writes a whole one
/// as an `integerValue`. So `{from: 25000, to: 90000.5}` genuinely comes back
/// as `{int, double}`.
///
/// `Map<String, double>.from(...)` on that throws
/// "type 'int' is not a subtype of type 'double' in type cast". Going through
/// `num` accepts either and normalises to double.
double vendorNumber(dynamic raw, {double fallback = 0}) {
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw) ?? fallback;
  return fallback;
}

/// The `budget` map, accepting int or double for either bound.
///
/// A missing or malformed budget yields zeros rather than throwing: a listing
/// with an odd budget should still be viewable and reviewable.
Map<String, double> vendorBudget(dynamic raw) {
  if (raw is! Map) return {'from': 0, 'to': 0};

  return {
    'from': vendorNumber(raw['from']),
    'to': vendorNumber(raw['to']),
  };
}

/// The `images` array as a list of plain maps.
///
/// Tolerates a missing or null field — an older listing may have none — so
/// callers get an empty list instead of a cast error.
List<Map<String, dynamic>> vendorImages(dynamic raw) {
  if (raw is! List) return const [];

  return raw
      .whereType<Map>()
      .map((entry) => Map<String, dynamic>.from(entry))
      .toList();
}

/// The image reference for one entry of `images`.
///
/// Two generations of writer, two field names, and both must keep working:
///
///  * `imagePath` — written since the R2 migration. An R2 object key.
///  * `imageUrl`  — written before it. A Firebase Storage download URL.
///
/// The media resolver already tells an object key from a URL, so the only job
/// here is to find whichever field this document happens to carry. Returns
/// null when neither is present, which callers render as a placeholder.
String? vendorImageRef(Map<String, dynamic> entry) {
  final path = entry['imagePath'];
  if (path is String && path.trim().isNotEmpty) return path;

  final url = entry['imageUrl'];
  if (url is String && url.trim().isNotEmpty) return url;

  return null;
}

/// The caption for one entry of `images`.
String vendorImageCaption(Map<String, dynamic> entry) {
  final text = entry['text'];
  return text is String ? text : '';
}

/// A plain string field, or '' when absent — never a failed cast.
String vendorText(dynamic raw) => raw is String ? raw : '';

/// Where a listing sits in the review workflow.
///
/// The three Checklist tabs are a view of this one value. Deriving it in a
/// single place is what keeps them mutually exclusive: a card decides which
/// actions to offer from the document it was given, not from which tab it
/// happens to be sitting in.
enum VendorDecision { pending, accepted, rejected }

/// The decision recorded on a vendor document.
///
/// Rejection is tested first so that a legacy document carrying both flags —
/// written before the two were always set together — resolves to one state
/// instead of reading as accepted in one place and rejected in another.
VendorDecision vendorDecisionOf(Map<String, dynamic> data) {
  if (data['isRejected'] == true) return VendorDecision.rejected;
  if (data['isAccepted'] == true) return VendorDecision.accepted;
  return VendorDecision.pending;
}
