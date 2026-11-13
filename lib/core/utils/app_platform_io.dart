import 'dart:io' as io;

/// Native (Desktop, Mobile, VM Test) implementation of platform utilities.
class AppPlatform {
  static const bool isWeb = false;

  static bool get isTest {
    try {
      return io.Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  static bool get isAndroid {
    try {
      return io.Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  static bool get isWindows {
    try {
      return io.Platform.isWindows;
    } catch (_) {
      return false;
    }
  }

  static bool get isDesktop {
    try {
      return io.Platform.isWindows || io.Platform.isMacOS || io.Platform.isLinux;
    } catch (_) {
      return false;
    }
  }
}
