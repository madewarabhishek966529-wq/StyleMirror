/// Universal StyleMirror API Service with conditional compilation.
/// Resolves to `api_service_stub.dart` on Web (pure Dart, zero `dart:io` symbols)
/// and `api_service_io.dart` on native desktop/mobile platforms.
export 'api_service_stub.dart'
    if (dart.library.io) 'api_service_io.dart';
