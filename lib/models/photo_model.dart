/// Model representing the response when a user photo is uploaded and validated
class PhotoUploadResponse {
  final String photoId;
  final bool ok;
  final List<String> issues;
  final int expiresIn;
  final String? storagePath;
  final String? previewBase64;

  const PhotoUploadResponse({
    required this.photoId,
    required this.ok,
    this.issues = const [],
    this.expiresIn = 86400,
    this.storagePath,
    this.previewBase64,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      photoId: json['photo_id'] as String? ?? json['photoId'] as String? ?? '',
      ok: json['ok'] as bool? ?? false,
      issues: (json['issues'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 86400,
      storagePath: json['storage_path'] as String?,
      previewBase64: json['preview_base64'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_id': photoId,
      'ok': ok,
      'issues': issues,
      'expires_in': expiresIn,
      if (storagePath != null) 'storage_path': storagePath,
      if (previewBase64 != null) 'preview_base64': previewBase64,
    };
  }

  /// User-friendly message for validation issues
  static String formatIssue(String issueCode) {
    switch (issueCode) {
      case 'NO_FACE':
        return 'No face detected. Please face the camera directly in good lighting.';
      case 'MULTIPLE_FACES':
        return 'Multiple faces found. Please upload a solo portrait selfie.';
      case 'FACE_TOO_SMALL':
        return 'Face is too far from camera. Center your face closer in the frame.';
      case 'TOO_BLURRY':
        return 'Photo appears blurry. Hold camera steady and capture with good focus.';
      case 'TOO_DARK':
        return 'Photo is too dark. Increase lighting or face a light source.';
      case 'FACE_NOT_FRONTAL':
        return 'Head is tilted or turned. Look straight ahead into the camera.';
      case 'FILE_TOO_LARGE':
        return 'File exceeds maximum 8 MB limit.';
      case 'UNSUPPORTED_TYPE':
        return 'Unsupported format. Please upload JPG, PNG, or WEBP.';
      default:
        return 'Validation warning: $issueCode';
    }
  }
}
