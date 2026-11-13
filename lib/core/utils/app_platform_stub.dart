/// Web implementation of platform utilities.
/// Pure Dart with zero `dart:io` imports to guarantee 100% web browser compatibility.
class AppPlatform {
  static const bool isWeb = true;
  static const bool isTest = false;
  static const bool isAndroid = false;
  static const bool isWindows = false;
  static const bool isDesktop = false;
}
