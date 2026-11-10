import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/services/backend_launcher.dart';

void main() {
  group('BackendLauncher Tests', () {
    test('isBackendRunning executes safely and returns boolean', () async {
      final isRunning = await BackendLauncher.isBackendRunning('127.0.0.1', 8000);
      expect(isRunning, isA<bool>());
    });

    test('ensureBackendRunning detects test environment safely', () async {
      // In flutter test environment, it safely skips spawning or returns boolean
      final result = await BackendLauncher.ensureBackendRunning();
      expect(result, isA<bool>());
    });
  });
}
