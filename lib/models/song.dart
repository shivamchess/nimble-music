class Song {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final int durationSeconds;
  final String? coverUrl;
  final String? localFilePath;
  final bool hasLyrics;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.durationSeconds = 210,
    this.coverUrl,
    this.localFilePath,
    this.hasLyrics = false,
    this.isFavorite = false,
  });

  factory Song.fromJson(Map<String, dynamic> json, String baseUrl) {
    final filename = json['filename'] as String? ?? '';
    return Song(
      id: filename.isNotEmpty ? filename : (json['id'] ?? DateTime.now().toString()),
      title: json['title'] ?? (filename.replaceAll('.mp3', '')),
      artist: json['artist'] ?? 'Unknown Artist',
      duration: json['duration'] ?? '3:30',
      durationSeconds: json['durationSeconds'] ?? 210,
      coverUrl: filename.isNotEmpty ? '$baseUrl/api/cover/$filename' : json['coverUrl'],
      localFilePath: json['filePath'],
      hasLyrics: json['has_lyrics'] == true,
      isFavorite: json['isFavorite'] == true,
    );
  }
}
