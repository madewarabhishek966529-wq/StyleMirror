/// Universal platform checker with conditional compilation.
/// Resolves to `app_platform_stub.dart` on Web (preventing `dart:io` crashes)
/// and `app_platform_io.dart` on native desktop, mobile, and VM test platforms.
export 'app_platform_stub.dart'
    if (dart.library.io) 'app_platform_io.dart';
