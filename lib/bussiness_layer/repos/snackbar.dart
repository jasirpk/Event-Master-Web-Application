import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String title,
  String message,
) {
  showCustomSnackBarOn(ScaffoldMessenger.of(context), title, message);
}

/// The same bar, addressed to a messenger captured earlier.
///
/// A card that reports the result of its own write is usually gone by the time
/// the write lands — accepting a listing removes it from the tab it was in, so
/// its State is disposed. Reading `ScaffoldMessenger.of(context)` at that
/// point is a use-after-unmount, and the confirmation is simply lost. Callers
/// capture the messenger before awaiting and tell it the outcome afterwards.
void showCustomSnackBarOn(
  ScaffoldMessengerState messenger,
  String title,
  String message,
) {
  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
