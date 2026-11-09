/// API Constants for StyleMirror
class ApiConstants {
  /// Base API URL - default localhost port 8000
  static const String defaultBaseUrl = 'http://127.0.0.1:8000';
  
  /// Android emulator loopback
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:8000';

  static const String stylesEndpoint = '/v1/styles';
  static const String photosEndpoint = '/v1/photos';
  static const String generationsEndpoint = '/v1/generations';
  static const String filesEndpoint = '/v1/files';

  /// Maximum photo size in bytes (8 MB)
  static const int maxPhotoSizeBytes = 8 * 1024 * 1024;

  /// Photo retention time in hours
  static const int photoTtlHours = 24;

  /// Polling interval for generation jobs in milliseconds
  static const int pollingIntervalMs = 1500;

  /// Timeout for network requests in seconds
  static const int timeoutSeconds = 30;
}
