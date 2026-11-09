import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/services/api_service.dart';

void main() {
  group('StyleMirrorApiService Tests', () {
    late StyleMirrorApiService apiService;

    setUp(() {
      apiService = StyleMirrorApiService(useMockFallback: true);
    });

    test('fetchStyles returns all 50 styles in fallback mode', () async {
      final styles = await apiService.fetchStyles();
      expect(styles.length, 50);

      final hairStyles = await apiService.fetchStyles(type: 'hair');
      expect(hairStyles.length, 25);
      expect(hairStyles.every((s) => s.isHair), true);

      final beardStyles = await apiService.fetchStyles(type: 'beard');
      expect(beardStyles.length, 25);
      expect(beardStyles.every((s) => s.isBeard), true);
    });

    test('uploadPhoto handles simulated validation error and success', () async {
      final dummyBytes = Uint8List.fromList([1, 2, 3, 4]);

      // Error simulation
      final errorRes = await apiService.uploadPhoto(
        bytes: dummyBytes,
        filename: 'test.jpg',
        simulateError: true,
      );
      expect(errorRes.ok, false);
      expect(errorRes.issues.contains('NO_FACE'), true);

      // Success upload
      final successRes = await apiService.uploadPhoto(
        bytes: dummyBytes,
        filename: 'test.jpg',
      );
      expect(successRes.ok, true);
      expect(successRes.photoId.isNotEmpty, true);
    });

    test('createGeneration and getGeneration lifecycle', () async {
      final job = await apiService.createGeneration(
        photoId: 'photo_123',
        hairStyleId: 'H01',
        beardStyleId: 'B01',
      );

      expect(job.id.isNotEmpty, true);
      expect(job.photoId, 'photo_123');

      final polledJob = await apiService.getGeneration(job.id);
      expect(polledJob.id, job.id);
      expect(polledJob.id.isNotEmpty, true);
    });

    test('deletePhoto succeeds', () async {
      final success = await apiService.deletePhoto('photo_test_to_delete');
      expect(success, true);
    });
  });
}
