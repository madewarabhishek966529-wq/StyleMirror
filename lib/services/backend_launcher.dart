import 'dart:async';
import 'dart:io';

/// Automatic Backend Lifecycle Manager for StyleMirror
/// Detects if the FastAPI Python backend is running on port 8000;
/// if not, automatically launches it in the background so the user
/// never has to run the backend separately.
class BackendLauncher {
  static Process? _backendProcess;

  /// Check health endpoint to see if backend is already listening
  static Future<bool> isBackendRunning([String host = '127.0.0.1', int port = 8000]) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 700);
      final request = await client.getUrl(Uri.parse('http://$host:$port/health'));
      final response = await request.close().timeout(const Duration(milliseconds: 700));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Automatically launches the Python FastAPI backend if not already active
  static Future<bool> ensureBackendRunning() async {
    // 1. Skip if running inside flutter test environment
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return false;
    }

    // 2. Only Desktop OS can directly spawn host Python processes
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) {
      return false;
    }

    // 3. If already running on port 8000, nothing to do
    if (await isBackendRunning()) {
      return true;
    }

    // 4. Find the backend directory
    final backendDir = _findBackendDirectory();
    if (backendDir == null) {
      return false;
    }

    // 5. Try candidate python executables: python, python3, py
    final candidates = Platform.isWindows ? ['python', 'py', 'python3'] : ['python3', 'python'];

    for (final py in candidates) {
      try {
        final proc = await Process.start(
          py,
          [
            '-m',
            'uvicorn',
            'app.main:app',
            '--host',
            '0.0.0.0',
            '--port',
            '8000',
          ],
          workingDirectory: backendDir.path,
          environment: {
            ...Platform.environment,
            'PYTHONPATH': backendDir.path,
          },
          mode: ProcessStartMode.detached,
        );

        _backendProcess = proc;

        // Poll for up to 4 seconds for backend to become ready
        for (int i = 0; i < 8; i++) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (await isBackendRunning()) {
            return true;
          }
        }
      } catch (_) {
        // Try next candidate executable
      }
    }

    return false;
  }

  /// Locate the backend directory by searching current working directory and parents
  static Directory? _findBackendDirectory() {
    Directory current = Directory.current;
    for (int i = 0; i < 4; i++) {
      final candidate = Directory('${current.path}${Platform.pathSeparator}backend');
      final mainPy = File('${candidate.path}${Platform.pathSeparator}app${Platform.pathSeparator}main.py');
      if (mainPy.existsSync()) {
        return candidate;
      }
      final parent = current.parent;
      if (parent.path == current.path) break;
      current = parent;
    }
    return null;
  }

  /// Optional helper to stop spawned process on app termination
  static void stopBackend() {
    try {
      _backendProcess?.kill();
      _backendProcess = null;
    } catch (_) {}
  }
}

