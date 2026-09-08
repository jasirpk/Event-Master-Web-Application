/// Thrown when a selected file's extension isn't one the Media API accepts
/// (image/jpeg, image/png, image/webp).
class UnsupportedImageTypeException implements Exception {
  final String fileName;
  UnsupportedImageTypeException(this.fileName);

  @override
  String toString() =>
      'UnsupportedImageTypeException: "$fileName" is not a supported image type (allowed: .jpg, .jpeg, .png, .webp)';
}

/// Maps a selected file's extension to the MIME type the Media API accepts.
///
/// Throws [UnsupportedImageTypeException] for anything else, so an unsupported
/// file fails before the Media API is ever called. The returned value must
/// match the API's allowlist exactly — it is signed into the presigned PUT, so
/// R2 rejects an upload whose Content-Type differs.
String imageContentTypeFromFileName(String fileName) {
  final dotIndex = fileName.lastIndexOf('.');
  final extension =
      dotIndex == -1 ? '' : fileName.substring(dotIndex + 1).toLowerCase();

  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    default:
      throw UnsupportedImageTypeException(fileName);
  }
}
