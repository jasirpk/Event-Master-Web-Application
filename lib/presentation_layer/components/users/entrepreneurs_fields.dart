import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/services/user_profile/profile.dart';
import 'package:event_master_web/presentation_layer/components/media/media_image.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/checklist.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/entrepreneur_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntrepreneursFieldsWidget extends StatefulWidget {
  const EntrepreneursFieldsWidget({
    super.key,
    required this.documentId,
    required this.screenHeight,
    required this.imagePath,
    required this.userDetail,
    required this.vendorDetail,
    required this.isValid,
    required this.userProfile,
  });

  final String documentId;
  final double screenHeight;
  final String imagePath;
  final Map<String, dynamic> userDetail;
  final Map<String, dynamic> vendorDetail;

  /// Whether this profile is already discoverable by consumers.
  final bool isValid;

  final UserProfile userProfile;

  @override
  State<EntrepreneursFieldsWidget> createState() =>
      _EntrepreneursFieldsWidgetState();
}

class _EntrepreneursFieldsWidgetState extends State<EntrepreneursFieldsWidget> {
  /// Guards a second tap while the write is in flight. The grid is driven by
  /// a snapshot stream so the card updates itself once the write lands, but
  /// the round trip is long enough to double-submit without this.
  bool _approving = false;

  /// A stored string, or '' — never a failed cast on an older profile.
  static String _text(dynamic raw) => raw is String ? raw : '';

  /// A stored list of maps, tolerating a missing field or a malformed row.
  static List<Map<String, dynamic>> _mapList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Asks before making the profile public, then writes the single field.
  Future<void> _approve() async {
    if (_approving || widget.isValid) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Approve this entrepreneur?'),
        content: Text(
          'Once approved, ${widget.userDetail['companyName'] ?? 'this profile'} '
          'becomes visible to consumers in Event Master. This does not accept '
          'any of their vendor listings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _approving = true);

    try {
      // The uid is the document's own id — never anything an operator typed.
      await widget.userProfile.approveEntrepreneur(widget.documentId);

      if (!mounted) return;
      showCustomSnackBar(context, 'Approved',
          'This entrepreneur is now visible to consumers.');
    } catch (_) {
      if (!mounted) return;
      // The rules reject a non-admin write, so this is also the path an
      // operator without the admin claim lands on.
      showCustomSnackBar(context, 'Could not approve',
          'The profile was not approved. Check that you are signed in as an administrator.');
    } finally {
      if (mounted) setState(() => _approving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documentId = widget.documentId;
    final screenHeight = widget.screenHeight;
    final imagePath = widget.imagePath;
    final userDetail = widget.userDetail;
    final vendorDetail = widget.vendorDetail;

    return InkWell(
      onTap: () {
        Get.to(() => ChecklistScreen(
              uid: documentId,
            ));
      },
      // profileImage is an R2 object key since the profile migration, so it
      // has to be signed before it is displayable. `startsWith('http')` sent
      // every key down the AssetImage branch, asking Flutter for a bundled
      // asset named "profile_images/..." — which does not exist, so the
      // DecorationImage drew nothing and the card looked blank.
      child: MediaImage(
        imagePath: imagePath,
        placeholder: kMediaPlaceholderImage,
        builder: (context, image) => Container(
          height: screenHeight * 0.3,
          decoration: BoxDecoration(
            color: const Color(0xFF37474F),
            borderRadius: BorderRadius.circular(10),
            image: image == null
                ? null
                : DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
            border: Border.all(color: Colors.teal),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3)),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          userDetail['companyName'],
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.028,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _StatusBadge(
                          isValid: widget.isValid, approving: _approving),
                      PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'approve') {
                            await _approve();
                          } else if (value == 'View Detail') {
                            Get.to(() => EntrepreneurDetailScreen(
                                companyName: _text(userDetail['companyName']),
                                about: _text(userDetail['description']),
                                phoneNumber: _text(userDetail['phoneNumber']),
                                bussinessEmail:
                                    _text(userDetail['emailAddress']),
                                website: _text(userDetail['website']),
                                imagePath: imagePath,
                                isValid: widget.isValid,
                                // The entrepreneur document carries no
                                // location of its own; the card already shows
                                // the one from their first vendor listing.
                                location: vendorDetail['location'] as String?,
                                // Unguarded .from() threw for any profile
                                // that had never saved links or portfolio.
                                links: _mapList(userDetail['links']),
                                images: _mapList(userDetail['images'])));
                          } else if (value == 'delete') {}
                        },
                        itemBuilder: (context) {
                          return [
                            // A deliberate, one-way decision, so it only
                            // appears while the profile is still pending.
                            if (!widget.isValid)
                              PopupMenuItem(
                                enabled: !_approving,
                                child:
                                    Text(_approving ? 'Approving…' : 'Approve'),
                                value: 'approve',
                              ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                            PopupMenuItem(
                              child: Text('View Detail'),
                              value: 'View Detail',
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  // An entrepreneur with no listing left to read has no
                  // location to show. Text() rejects a null, and a lone pin
                  // beside an empty string reads as a rendering fault, so the
                  // line is simply omitted.
                  if (_text(vendorDetail['location']).isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: myColor,
                          size: 20,
                        ),
                        Text(
                          _text(vendorDetail['location']),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: screenHeight * 0.026,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pending / Approved, shown on the card so an operator can see at a glance
/// which profiles consumers can actually find.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isValid, required this.approving});

  final bool isValid;
  final bool approving;

  @override
  Widget build(BuildContext context) {
    if (approving) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isValid ? Colors.teal : Colors.orange.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isValid ? 'Approved' : 'Pending',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
