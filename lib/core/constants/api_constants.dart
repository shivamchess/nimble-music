class ApiConstants {
  // Default emulator / LAN URL for Python backend
  static const String defaultBaseUrl = "http://10.0.2.2:54321";
  static const String localhostUrl = "http://127.0.0.1:54321";

  static const String endpointSongs = "/api/songs";
  static const String endpointLyrics = "/api/lyrics";
  static const String endpointStreamLive = "/api/stream-live";
  static const String endpointCover = "/api/cover";
  static const String endpointDefaultCover = "/api/default-cover";
  static const String endpointDownload = "/api/download";
  static const String endpointSyncLyrics = "/api/sync-lyrics";
}
