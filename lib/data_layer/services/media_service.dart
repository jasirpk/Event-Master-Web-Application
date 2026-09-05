import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Base URL of the Media API.
///
/// No environment/config mechanism exists elsewhere in this project yet, so
/// this is the smallest reasonable approach: a single, override-able build
/// constant rather than a multi-environment config layer. Override it at
/// build/run time, e.g.:
///   flutter run --dart-define=MEDIA_API_BASE_URL=https://media.example.com
/// The default below is a placeholder and must be overridden for real use.
const String kMediaApiBaseUrl = String.fromEnvironment(
  'MEDIA_API_BASE_URL',
  defaultValue: 'https://media-api.event-master.example',
);

/// Thrown when a Media API request fails or returns an unexpected response.
///
/// Never carries the Authorization header or a presigned URL — only a
/// message, the HTTP status (if any), and a truncated response body.
class MediaApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  MediaApiException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() {
    final status = statusCode != null ? ' (status $statusCode)' : '';
    final body = responseBody != null ? ' — $responseBody' : '';
    return 'MediaApiException: $message$status$body';
  }
}

/// Client for the existing Node.js Media API — presigned-URL upload/download
/// against Cloudflare R2.
///
/// Image bytes are uploaded directly from the browser to R2 using the
/// presigned URL the Media API returns; they never pass through this app's
/// own backend beyond that one presign request. This service does not touch
/// Firebase Storage, Firestore, or any UI/state layer — it only talks to the
/// Media API and, for the PUT step, directly to R2.
///
/// Authorization is entirely the Media API's responsibility: this service
/// just attaches the current Firebase ID token. It does not check or
/// duplicate the admin-claim logic that lives in AuthBloc.
class MediaService {
  final http.Client _client;

  MediaService({http.Client? client}) : _client = client ?? http.Client();

  /// Uploads [bytes] as [fileName] ([contentType]) for [entityId], under
  /// [folder] (defaults to 'category_images', the only folder this app uses
  /// today). Returns the R2 object key — store only this in Firestore, never
  /// the presigned URL.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String entityId,
    required String fileName,
    required String contentType,
    String folder = 'category_images',
  }) async {
    final token = await _currentIdToken();

    final presignResponse = await _client.post(
      Uri.parse('$kMediaApiBaseUrl/api/media/upload-url'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'folder': folder,
        'entityId': entityId,
        'fileName': fileName,
        'contentType': contentType,
        'contentLength': bytes.length,
      }),
    );

    if (presignResponse.statusCode != 200) {
      throw MediaApiException(
        'Failed to obtain an upload URL from the Media API',
        statusCode: presignResponse.statusCode,
        responseBody: _safeBody(presignResponse.body),
      );
    }

    final Map<String, dynamic> presign =
        jsonDecode(presignResponse.body) as Map<String, dynamic>;

    final String? uploadUrl = presign['uploadUrl'] as String?;
    final String? objectKey = presign['objectKey'] as String?;
    final String uploadContentType =
        presign['contentType'] as String? ?? contentType;

    if (uploadUrl == null || objectKey == null) {
      throw MediaApiException(
        'Media API returned an incomplete upload-url response',
        statusCode: presignResponse.statusCode,
      );
    }

    // Bytes go straight to R2 with the presigned URL — no Firebase token on
    // this request. 'Content-Length' is deliberately not set by hand: it is
    // a forbidden/no-op header for browser HTTP clients (fetch/XHR), and
    // package:http already sends the correct length computed from [bytes].
    final putResponse = await _client.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': uploadContentType},
      body: bytes,
    );

    if (putResponse.statusCode != 200 && putResponse.statusCode != 201) {
      throw MediaApiException(
        'Failed to upload the image to R2',
        statusCode: putResponse.statusCode,
      );
    }

    return objectKey;
  }

  /// Resolves a temporary (~5 minute) signed GET URL for [objectKey].
  ///
  /// Never cache or persist the returned URL — request a fresh one whenever
  /// the image needs to be displayed.
  Future<String> getDownloadUrl(String objectKey) async {
    final token = await _currentIdToken();

    final response = await _client.get(
      Uri.parse('$kMediaApiBaseUrl/api/media/download-url').replace(
        queryParameters: {'objectKey': objectKey},
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw MediaApiException(
        'Failed to obtain a download URL from the Media API',
        statusCode: response.statusCode,
        responseBody: _safeBody(response.body),
      );
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    final String? downloadUrl = body['downloadUrl'] as String?;

    if (downloadUrl == null) {
      throw MediaApiException(
        'Media API returned an incomplete download-url response',
        statusCode: response.statusCode,
      );
    }

    return downloadUrl;
  }

  Future<String> _currentIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw MediaApiException('No signed-in Firebase user');
    }
    final token = await user.getIdToken(true);
    if (token == null) {
      throw MediaApiException('Firebase did not return an ID token');
    }
    return token;
  }

  /// Truncates a response body before it goes into an exception message, so
  /// an unexpectedly large response never balloons a log/error line.
  String _safeBody(String body) {
    const maxLength = 500;
    return body.length > maxLength ? '${body.substring(0, maxLength)}…' : body;
  }
}
