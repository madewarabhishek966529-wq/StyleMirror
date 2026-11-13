import 'dart:async';
import 'dart:typed_data';

import '../core/constants/api_constants.dart';
import '../models/generation_model.dart';
import '../models/photo_model.dart';
import '../models/style_model.dart';
import '../data/style_catalog_data.dart';

/// StyleMirror API Client for Web environments.
/// Pure Dart implementation with zero `dart:io` imports to guarantee full browser compatibility.
class StyleMirrorApiService {
  final String baseUrl;
  bool useMockFallback;

  StyleMirrorApiService({String? baseUrl, this.useMockFallback = true})
      : baseUrl = baseUrl ?? ApiConstants.defaultBaseUrl;

  final Map<String, GenerationJob> _mockJobs = {};
  final Set<String> _mockDeletedPhotos = {};

  /// Fetch styles from local catalog
  Future<List<StyleModel>> fetchStyles({String? type}) async {
    if (type == 'hair') {
      return StyleCatalogData.hairstyles;
    } else if (type == 'beard') {
      return StyleCatalogData.beardStyles;
    }
    return StyleCatalogData.allStyles;
  }

  /// Upload selfie photo for validation
  Future<PhotoUploadResponse> uploadPhoto({
    required Uint8List bytes,
    required String filename,
    bool simulateError = false,
  }) async {
    if (simulateError) {
      return const PhotoUploadResponse(
        photoId: '',
        ok: false,
        issues: ['NO_FACE'],
      );
    }

    final mockPhotoId = 'photo_${DateTime.now().millisecondsSinceEpoch}';
    return PhotoUploadResponse(
      photoId: mockPhotoId,
      ok: true,
      issues: [],
      expiresIn: 86400,
    );
  }

  /// Initiate a generation job with HairFast parameters
  Future<GenerationJob> createGeneration({
    required String photoId,
    String? hairStyleId,
    String? beardStyleId,
    String hairColor = 'natural',
    String view = 'front',
  }) async {
    final jobId = 'job_${DateTime.now().millisecondsSinceEpoch}';
    final job = GenerationJob(
      id: jobId,
      photoId: photoId,
      hairStyleId: hairStyleId,
      beardStyleId: beardStyleId,
      hairColor: hairColor,
      view: view,
      status: GenerationStatus.done,
      identityScore: 0.94,
      createdAt: DateTime.now(),
    );
    _mockJobs[jobId] = job;
    return job;
  }

  /// Poll status of a generation job
  Future<GenerationJob> getGeneration(String jobId) async {
    final job = _mockJobs[jobId];
    if (job != null) {
      return job;
    }

    return GenerationJob(
      id: jobId,
      photoId: 'photo_demo',
      status: GenerationStatus.done,
      identityScore: 0.94,
    );
  }

  /// Delete photo and all generated looks immediately
  Future<bool> deletePhoto(String photoId) async {
    _mockDeletedPhotos.add(photoId);
    return true;
  }
}

