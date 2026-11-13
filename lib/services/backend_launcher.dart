/// Universal BackendLauncher with conditional compilation.
/// Resolves to `backend_launcher_stub.dart` on Web (no `dart:io` symbols)
/// and `backend_launcher_io.dart` on native desktop platforms.
export 'backend_launcher_stub.dart'
    if (dart.library.io) 'backend_launcher_io.dart';
