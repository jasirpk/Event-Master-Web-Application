import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/media/media_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The platform administrator's read-only view of one entrepreneur profile.
///
/// Read-only is a property worth stating: opening this screen performs no
/// Firestore write of any kind. Approval stays on the Entrepreneurs card,
/// which owns that decision.
///
/// Every image here is a Cloudflare R2 object key — `profile_images/…` for
/// the avatar and `profile_portfolio/…` for the portfolio — or a legacy
/// Firebase Storage URL on an older profile. Both go through [MediaImage],
/// which signs the former and passes the latter straight through.
class EntrepreneurDetailScreen extends StatelessWidget {
  final String companyName;
  final String about;
  final String phoneNumber;
  final String bussinessEmail;
  final String website;
  final String imagePath;
  final List<Map<String, dynamic>> links;
  final List<Map<String, dynamic>> images;

  /// Whether consumers can already discover this profile.
  final bool isValid;

  /// Shown when the profile has one. Entrepreneur documents do not always
  /// carry a location, so it is optional rather than blank.
  final String? location;

  const EntrepreneurDetailScreen({
    super.key,
    required this.companyName,
    required this.about,
    required this.phoneNumber,
    required this.bussinessEmail,
    required this.website,
    required this.imagePath,
    required this.links,
    required this.images,
    this.isValid = false,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // The console runs anywhere from a laptop to an ultrawide, so the body is
    // centred and capped rather than stretched edge to edge.
    final horizontalPadding = width > 1200 ? (width - 1100) / 2 : 24.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(companyName.isEmpty ? 'Entrepreneur' : companyName),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                companyName: companyName,
                imagePath: imagePath,
                isValid: isValid,
                location: location,
              ),
              const SizedBox(height: 28),
              _Section(
                title: 'About',
                child: Text(
                  about.trim().isEmpty ? 'No description provided.' : about,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Contact',
                child: _ContactGrid(
                  phoneNumber: phoneNumber,
                  email: bussinessEmail,
                  website: website,
                  wide: width > 900,
                ),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Portfolio',
                trailing: images.isEmpty ? null : '${images.length}',
                child: _Portfolio(images: images, width: width),
              ),
              const SizedBox(height: 20),
              _Section(
                title: 'Links',
                child: _Links(links: links),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar, name, approval status and location.
class _Header extends StatelessWidget {
  const _Header({
    required this.companyName,
    required this.imagePath,
    required this.isValid,
    required this.location,
  });

  final String companyName;
  final String imagePath;
  final bool isValid;
  final String? location;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF37474F),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // An R2 object key, so it is signed before display. Reading it
            // with startsWith('http') sent the key to AssetImage, which is
            // why this showed an empty blue circle.
            MediaImage(
              imagePath: imagePath,
              placeholder: kMediaPlaceholderImage,
              builder: (context, image) => CircleAvatar(
                radius: 56,
                backgroundColor: Colors.black26,
                backgroundImage: image,
                child: image == null
                    ? const Icon(Icons.business,
                        size: 40, color: Colors.white54)
                    : null,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    companyName.isEmpty ? 'Unnamed company' : companyName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatusChip(isValid: isValid),
                      if ((location ?? '').trim().isNotEmpty) ...[
                        sizedBoxWidth,
                        Icon(Icons.location_on, size: 18, color: myColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            location!,
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

/// Mirrors the Pending / Approved badge on the Entrepreneurs card, so the two
/// screens agree at a glance.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isValid});

  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isValid ? Colors.teal : Colors.orange.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isValid ? 'Approved' : 'Pending',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// A titled card. One shape for every section so the page reads as one thing.
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: myColor,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  Text(trailing!,
                      style: const TextStyle(color: Colors.white54)),
                ],
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ContactGrid extends StatelessWidget {
  const _ContactGrid({
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.wide,
  });

  final String phoneNumber;
  final String email;
  final String website;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _ContactRow(icon: Icons.call, label: 'Phone', value: phoneNumber),
      _ContactRow(icon: Icons.email, label: 'Email', value: email),
      _ContactRow(icon: Icons.language, label: 'Website', value: website),
    ];

    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in rows) ...[row, const SizedBox(height: 12)],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final row in rows) Expanded(child: row)],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final shown = value.trim().isEmpty ? 'Not provided' : value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: myColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.white54)),
              const SizedBox(height: 2),
              // Selectable rather than tappable: the console has no
              // url_launcher dependency, and adding one to make a label
              // clickable is not worth a new package. An operator can copy
              // the value, which is what they do with it anyway.
              SelectableText(
                shown,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The portfolio grid.
///
/// Entries are `{image: <R2 key or legacy URL>}`. A malformed or empty entry
/// is skipped rather than allowed to throw — these documents were written by
/// two different clients over the migration.
class _Portfolio extends StatelessWidget {
  const _Portfolio({required this.images, required this.width});

  final List<Map<String, dynamic>> images;
  final double width;

  @override
  Widget build(BuildContext context) {
    final refs = <String>[];

    for (final entry in images) {
      final raw = entry['image'];
      if (raw is String && raw.trim().isNotEmpty) refs.add(raw);
    }

    if (refs.isEmpty) {
      return const Text('No portfolio images.',
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
      itemCount: refs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 200,
      ),
      itemBuilder: (context, index) => MediaImage(
        imagePath: refs[index],
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
    );
  }
}

/// Social links, in the stored `{link: <string>}` shape.
class _Links extends StatelessWidget {
  const _Links({required this.links});

  final List<Map<String, dynamic>> links;

  @override
  Widget build(BuildContext context) {
    final values = <String>[];

    for (final entry in links) {
      final raw = entry['link'];
      if (raw is String && raw.trim().isNotEmpty) values.add(raw.trim());
    }

    if (values.isEmpty) {
      return const Text('No links provided.',
          style: TextStyle(color: Colors.white54));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final link in values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.link, size: 18, color: Colors.white54),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    link,
                    style: const TextStyle(
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
