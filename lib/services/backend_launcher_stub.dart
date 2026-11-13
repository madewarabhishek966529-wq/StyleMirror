import 'dart:async';

/// Web implementation of BackendLauncher.
/// Browsers cannot spawn OS processes or inspect localhost sockets directly via `dart:io`.
class BackendLauncher {
  /// Always returns false on web (backend runs as independent remote or local API)
  static Future<bool> isBackendRunning([String host = '127.0.0.1', int port = 8000]) async => false;

  /// No-op on web
  static Future<bool> ensureBackendRunning() async => false;

  /// No-op on web
  static void stopBackend() {}
}
