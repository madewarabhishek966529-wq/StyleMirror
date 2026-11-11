import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/models/generation_model.dart';
import 'package:stylemirror/models/photo_model.dart';
import 'package:stylemirror/models/style_model.dart';

void main() {
  group('Models Serialization Tests', () {
    test('StyleModel toJson and fromJson match', () {
      const style = StyleModel(
        id: 'H03',
        type: 'hair',
        name: 'French Crop',
        promptHint: 'short textured top with fringe',
        thumbUrl: '/thumb.jpg',
        category: 'Textured Crop',
        tags: ['crop', 'modern'],
        sortOrder: 3,
      );

      final json = style.toJson();
      final fromJson = StyleModel.fromJson(json);

      expect(fromJson.id, 'H03');
      expect(fromJson.name, 'French Crop');
      expect(fromJson.isHair, true);
      expect(fromJson.isBeard, false);
      expect(fromJson.tags.contains('crop'), true);
    });

    test('PhotoUploadResponse serialization and formatIssue', () {
      const res = PhotoUploadResponse(
        photoId: 'photo_abc123',
        ok: true,
        issues: [],
        expiresIn: 86400,
      );

      final json = res.toJson();
      final fromJson = PhotoUploadResponse.fromJson(json);

      expect(fromJson.photoId, 'photo_abc123');
      expect(fromJson.ok, true);
      expect(fromJson.faceCount, 1);

      expect(PhotoUploadResponse.formatIssue('NO_FACE').contains('No face detected'), true);
      expect(PhotoUploadResponse.formatIssue('MULTIPLE_FACES').contains('Multiple faces'), true);
      expect(PhotoUploadResponse.formatIssue('TOO_BLURRY').contains('blurry'), true);
      expect(PhotoUploadResponse.formatIssue('FACE_NOT_FRONTAL').contains('Look straight ahead'), true);
    });

    test('GenerationJob serialization and status progression', () {
      final job = GenerationJob(
        id: 'job_xyz987',
        photoId: 'photo_abc123',
        hairStyleId: 'H01',
        beardStyleId: 'B02',
        status: GenerationStatus.done,
        resultUrl: '/out.jpg',
        identityScore: 0.95,
        latencyMs: 12000,
      );

      final json = job.toJson();
      final fromJson = GenerationJob.fromJson(json);

      expect(fromJson.id, 'job_xyz987');
      expect(fromJson.status, GenerationStatus.done);
      expect(fromJson.isDone, true);
      expect(fromJson.isProcessing, false);
      expect(fromJson.identityScore, 0.95);
    });
  });
}
