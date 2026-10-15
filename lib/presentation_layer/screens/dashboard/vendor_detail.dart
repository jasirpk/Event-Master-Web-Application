import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/common/error_diagnostics.dart';
import 'package:event_master_web/data_layer/models/vendor_document.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/media/media_image.dart';
import 'package:event_master_web/presentation_layer/components/ui/vendor_decision_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The administrator's view of one vendor listing, and where it is decided.
///
/// The screen reads the document live rather than the values it was opened
/// with. That is what keeps the status badge honest: a listing accepted here,
/// or by someone else while this page is open, is reflected here instead of
/// leaving a stale "Pending" behind.
///
/// Every image is a Cloudflare R2 object key — `vendor_images/{uid}/{id}/…` —
/// or a legacy Firebase Storage URL on an older listing. Both go through
/// [MediaImage], which signs the former and passes the latter through.
class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({
    super.key,
    required this.uid,
    required this.vendorId,
    this.initial,
  });

  /// The entrepreneur who owns this listing.
  final String uid;

  /// The `vendorDetails` document id.
  final String vendorId;

  /// The copy the caller already had, painted while the stream connects so
  /// the page does not open on a spinner it does not need.
  final Map<String, dynamic>? initial;

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final VendorRequest _vendorRequest = VendorRequest();

  bool _busy = false;

  Future<void> _decide(
      {required bool accept, required String vendorName}) async {
    if (_busy) return;

    logStage('VendorDetail', 'decision tapped (accept=$accept)');
    try {
      await _runDecision(accept: accept, vendorName: vendorName);
    } catch (error, stack) {
      if (kErrorDiagnostics) {
        developer.log('Decision callback failed',
            name: 'VendorDetail', error: error, stackTrace: stack);
      }
      rethrow;
    }
  }

  Future<void> _runDecision(
      {required bool accept, required String vendorName}) async {
    final confirmed = await confirmVendorDecision(
      context,
      vendorName: vendorName,
      accept: accept,
    );
    if (!confirmed || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _busy = true);
    try {
      await applyVendorDecision(
        messenger: messenger,
        vendorRequest: _vendorRequest,
        uid: widget.uid,
        vendorId: widget.vendorId,
        accept: accept,
      );
      // No navigation on success. The stream delivers the new status and the
      // page re-renders around it, which is less jarring than being thrown
      // back to a tab the listing has just left.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _vendorRequest.watchVendor(widget.uid, widget.vendorId),
      builder: (context, snapshot) {
        final live = snapshot.data?.data();

        // Before the first snapshot arrives there is nothing newer than what
        // the caller handed over, so that is what gets drawn.
        final data = live ?? widget.initial;

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const _Missing();
        }
        if (data == null) {
          if (snapshot.hasError) return _Failed(error: '${snapshot.error}');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return _Detail(
          data: data,
          uid: widget.uid,
          busy: _busy,
          onDecide: (accept) => _decide(
            accept: accept,
            vendorName: vendorText(data['categoryName']),
          ),
        );
      },
    );
  }
}

/// The page itself, given one listing's data.
class _Detail extends StatelessWidget {
  const _Detail({
    required this.data,
    required this.uid,
    required this.busy,
    required this.onDecide,
  });

  final Map<String, dynamic> data;
  final String uid;
  final bool busy;
  final void Function(bool accept) onDecide;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // The console runs anywhere from a laptop to an ultrawide, so the body is
    // centred and capped rather than stretched edge to edge.
    final horizontalPadding = width > 1200 ? (width - 1100) / 2 : 24.0;

    final name = vendorText(data['categoryName']);
    final description = vendorText(data['description']);
    final decision = vendorDecisionOf(data);
    final components = vendorImages(data['images']);

    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? 'Vendor listing' : name),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                name: name,
                imagePath: vendorText(data['imagePathUrl']),
                decision: decision,
                location: vendorText(data['location']),
              ),
              const SizedBox(height: 28),
              _Section(
                title: 'Description',
                child: Text(
                  description.trim().isEmpty
                      ? 'No description provided.'
                      : description,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Listing details',
                child: _Facts(data: data, uid: uid, wide: width > 900),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Essential components',
                trailing:
                    components.isEmpty ? null : '${components.length}',
                child: _Components(components: components, width: width),
              ),
              const SizedBox(height: 28),
              _ActionBar(
                decision: decision,
                busy: busy,
                onDecide: onDecide,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main image, name, status and location.
class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.imagePath,
    required this.decision,
    required this.location,
  });

  final String name;
  final String imagePath;
  final VendorDecision decision;
  final String location;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: const Color(0xFF37474F),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MediaImage(
              imagePath: imagePath,
              placeholder: kMediaPlaceholderImage,
              builder: (context, image) => Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  image: image == null
                      ? null
                      : DecorationImage(image: image, fit: BoxFit.cover),
                ),
                child: image == null
                    ? const Center(
                        child: Icon(Icons.storefront,
                            size: 48, color: Colors.white54),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? 'Unnamed listing' : name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatusChip(decision: decision),
                      if (location.trim().isNotEmpty) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.decision});

  final VendorDecision decision;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;

    switch (decision) {
      case VendorDecision.accepted:
        color = Colors.teal;
        label = 'Accepted';
      case VendorDecision.rejected:
        color = Colors.red.shade700;
        label = 'Rejected';
      case VendorDecision.pending:
        color = Colors.orange.shade800;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// A titled panel, matching the entrepreneur detail page.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(trailing!,
                      style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

/// Location, budget, template origin and the owning entrepreneur.
class _Facts extends StatelessWidget {
  const _Facts({required this.data, required this.uid, required this.wide});

  final Map<String, dynamic> data;
  final String uid;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final location = vendorText(data['location']);
    final category = vendorText(data['categoryName']);
    final subCategoryId = vendorText(data['subCategoryId']);

    final rows = <Widget>[
      _Fact(
        icon: Icons.location_on,
        label: 'Location',
        value: location.trim().isEmpty ? 'Not specified' : location,
      ),
      _Fact(
        icon: Icons.attach_money,
        label: 'Budget range',
        value: _budgetText(data['budget']),
      ),
      _Fact(
        icon: Icons.category,
        label: 'Category',
        value: category.trim().isEmpty ? 'Not specified' : category,
      ),
      // Only a template-derived listing carries these; a standalone one omits
      // them entirely, which is why presence is what is tested.
      if (subCategoryId.trim().isNotEmpty)
        _Fact(
          icon: Icons.account_tree,
          label: 'Subcategory',
          value: subCategoryId,
        ),
      _Fact(
        icon: Icons.person,
        label: 'Entrepreneur',
        value: uid,
      ),
    ];

    if (!wide) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
    }

    return Wrap(
      spacing: 48,
      runSpacing: 4,
      children: [
        for (final row in rows) SizedBox(width: 420, child: row),
      ],
    );
  }

  /// The stored bounds, which may be int or double and may be missing.
  static String _budgetText(dynamic raw) {
    final budget = vendorBudget(raw);
    final from = budget['from'] ?? 0;
    final to = budget['to'] ?? 0;

    if (from == 0 && to == 0) return 'Not specified';
    return '${_number(from)} – ${_number(to)}';
  }

  /// Whole amounts read as amounts, not as 25000.0.
  static String _number(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white54)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The listing's component images and captions.
class _Components extends StatelessWidget {
  const _Components({required this.components, required this.width});

  final List<Map<String, dynamic>> components;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) {
      return const Text('No components listed.',
          style: TextStyle(color: Colors.white54));
    }

    final columns = width > 1100
        ? 4
        : width > 800
            ? 3
            : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: components.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 210,
      ),
      itemBuilder: (context, index) {
        final component = components[index];
        final caption = vendorImageCaption(component);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // A component stores its key under 'imagePath' since the
              // migration and under 'imageUrl' before it; vendorImageRef
              // finds whichever this document carries and returns null when
              // it carries neither.
              child: MediaImage(
                imagePath: vendorImageRef(component),
                placeholder: kMediaPlaceholderImage,
                builder: (context, image) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    image: image == null
                        ? null
                        : DecorationImage(image: image, fit: BoxFit.cover),
                  ),
                  child: image == null
                      ? const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.white38))
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              caption.trim().isEmpty ? 'Untitled component' : caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: caption.trim().isEmpty ? Colors.white38 : Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Accept and Reject, shown according to where the listing currently stands.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.decision,
    required this.busy,
    required this.onDecide,
  });

  final VendorDecision decision;
  final bool busy;
  final void Function(bool accept) onDecide;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Saving decision…'),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (decision != VendorDecision.accepted)
          FilledButton.icon(
            onPressed: () => onDecide(true),
            icon: const Icon(Icons.check),
            label: const Text('Accept listing'),
          ),
        if (decision != VendorDecision.rejected)
          FilledButton.icon(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => onDecide(false),
            icon: const Icon(Icons.close),
            label: const Text('Reject listing'),
          ),
      ],
    );
  }
}

/// The listing was removed while the page was open.
class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: const Center(
        child: Text('This listing is no longer available.'),
      ),
    );
  }
}

/// The listing could not be read.
class _Failed extends StatelessWidget {
  const _Failed({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Center(child: Text('Could not load this listing: $error')),
    );
  }
}
